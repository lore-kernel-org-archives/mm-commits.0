Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE227C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 02:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiD2Cuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 22:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiD2Cuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 22:50:50 -0400
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338A6517C3
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 19:47:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VBf.tfb_1651200445;
Received: from 192.168.31.113(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VBf.tfb_1651200445)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Apr 2022 10:47:26 +0800
Message-ID: <e868e056-1fb2-eb82-f98e-121c66f80e38@linux.alibaba.com>
Date:   Fri, 29 Apr 2022 10:47:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: + ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch added to
 -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, heming.zhao@suse.com,
        ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com
References: <20220428220012.34FD2C385A9@smtp.kernel.org>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20220428220012.34FD2C385A9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 4/29/22 6:00 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: rewrite error handling of ocfs2_fill_super
> has been added to the -mm tree.  Its filename is
>      ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> Subject: ocfs2: rewrite error handling of ocfs2_fill_super
> 
> Current ocfs2_fill_super() uses one goto label "read_super_error" to
> handle all error cases.  And with previous serial patches, the error
> handling should fork more branches to handle different error cases.  This
> patch rewrite the error handling of ocfs2_fill_super.
> 
> Link: https://lkml.kernel.org/r/20220424130952.2436-6-heming.zhao@suse.com
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/super.c |   67 +++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> --- a/fs/ocfs2/super.c~ocfs2-rewrite-error-handling-of-ocfs2_fill_super
> +++ a/fs/ocfs2/super.c
> @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super
>  
>  	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto out;
>  	}
>  
>  	/* probe for superblock */
>  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
>  	if (status < 0) {
>  		mlog(ML_ERROR, "superblock probe failed!\n");
> -		goto read_super_error;
> +		goto out;
>  	}
>  
>  	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
> -	osb = OCFS2_SB(sb);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto read_super_error;
> -	}
>  	brelse(bh);
>  	bh = NULL;
> +	if (status < 0)
> +		goto out;
> +
> +	osb = OCFS2_SB(sb);
>  
>  	if (!ocfs2_check_set_options(sb, &parsed_options)) {
>  		status = -EINVAL;
> -		goto read_super_error;
> +		goto out_super;
>  	}
>  	osb->s_mount_opt = parsed_options.mount_opt;
>  	osb->s_atime_quantum = parsed_options.atime_quantum;
> @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super
>  
>  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>  	if (status)
> -		goto read_super_error;
> +		goto out_super;
>  
>  	sb->s_magic = OCFS2_SUPER_MAGIC;
>  
> @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super
>  			status = -EACCES;
>  			mlog(ML_ERROR, "Readonly device detected but readonly "
>  			     "mount was not specified.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		/* You should not be able to start a local heartbeat
> @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super
>  			status = -EROFS;
>  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>  			     "device.\n");
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		status = ocfs2_check_journals_nolocks(osb);
> @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super
>  				mlog(ML_ERROR, "Recovery required on readonly "
>  				     "file system, but write access is "
>  				     "unavailable.\n");
> -			else
> -				mlog_errno(status);
> -			goto read_super_error;
> +			goto out_super;
>  		}
>  
>  		ocfs2_set_ro_flag(osb, 1);
> @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super
>  	}
>  
>  	status = ocfs2_verify_heartbeat(osb);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto read_super_error;
> -	}
> +	if (status < 0)
> +		goto out_super;
>  
>  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
>  						 ocfs2_debugfs_root);
> @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super
>  
>  	status = ocfs2_mount_volume(sb);
>  	if (status < 0)
> -		goto read_super_error;
> +		goto out_debugfs;
>  
>  	if (osb->root_inode)
>  		inode = igrab(osb->root_inode);
>  
>  	if (!inode) {
>  		status = -EIO;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super
>  	if (!osb->osb_dev_kset) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	/* Create filecheck sysfs related directories/files at
> @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	root = d_make_root(inode);
>  	if (!root) {
>  		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto read_super_error;
> +		goto out_dismount;
>  	}
>  
>  	sb->s_root = root;
> @@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super
>  
>  	return status;
>  
> -read_super_error:
> -	brelse(bh);
> -
> -	if (status)
> -		mlog_errno(status);
> +out_dismount:
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
> +	ocfs2_dismount_volume(sb, 1);
> +	goto out;
>  
> -	if (osb) {
> -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
> -		wake_up(&osb->osb_mount_event);
> -		ocfs2_dismount_volume(sb, 1);
> -	}
> +out_debugfs:
> +	debugfs_remove_recursive(osb->osb_debug_root);
> +out_super:
> +	ocfs2_release_system_inodes(osb);
> +	kfree(osb->recovery_map);
> +	ocfs2_delete_osb(osb);
> +	kfree(osb);
> +out:
> +	mlog_errno(status);
>  
>  	return status;
>  }
> _
> 
> Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are
> 
> ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
> ocfs2-change-return-type-of-ocfs2_resmap_init.patch
> ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
> ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
> ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
