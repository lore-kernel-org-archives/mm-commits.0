Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305ACC7EE29
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 01:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjEZBgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 21:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjEZBgd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 21:36:33 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAAD194
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 18:36:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VjU1w8w_1685064985;
Received: from 30.221.128.248(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VjU1w8w_1685064985)
          by smtp.aliyun-inc.com;
          Fri, 26 May 2023 09:36:26 +0800
Message-ID: <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
Date:   Fri, 26 May 2023 09:36:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        lhenriques@suse.de, junxiao.bi@oracle.com, jlbec@evilplan.org,
        ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com
References: <20230525205556.680DCC433EF@smtp.kernel.org>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230525205556.680DCC433EF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

There is an updated version v2, which describe more clearly about the
case:
https://lore.kernel.org/ocfs2-devel/e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com/T/#u

Thanks,
Joseph

On 5/26/23 4:55 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Luís Henriques <ocfs2-devel@oss.oracle.com>
> Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
> Date: Mon, 22 May 2023 11:21:12 +0100
> 
> It's trivial to trigger a use-after-free bug in the ocfs2 quotas code
> using fstest generic/452.  After mounting a filesystem as read-only,
> quotas are suspended and ocfs2_mem_dqinfo is freed through
> ->ocfs2_local_free_info().  When unmounting the filesystem, an UAF access
> to the oinfo will eventually cause a crash.
> 
> Link: https://lkml.kernel.org/r/20230522102112.9031-1-lhenriques@suse.de
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/super.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/fs/ocfs2/super.c~ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem
> +++ a/fs/ocfs2/super.c
> @@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct
>  	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
>  		if (!sb_has_quota_loaded(sb, type))
>  			continue;
> -		oinfo = sb_dqinfo(sb, type)->dqi_priv;
> -		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
> +		if (!sb_has_quota_suspended(sb, type)) {
> +			oinfo = sb_dqinfo(sb, type)->dqi_priv;
> +			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
> +		}
>  		inode = igrab(sb->s_dquot.files[type]);
>  		/* Turn off quotas. This will remove all dquot structures from
>  		 * memory and so they will be automatically synced to global
> _
> 
> Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are
> 
> ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch
