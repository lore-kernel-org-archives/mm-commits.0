Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5EEC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 02:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjEZCPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 22:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjEZCPo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 22:15:44 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA33183
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:15:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VjU6cH-_1685067334;
Received: from 30.221.128.248(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VjU6cH-_1685067334)
          by smtp.aliyun-inc.com;
          Fri, 26 May 2023 10:15:35 +0800
Message-ID: <bcea2cee-57e3-019f-3ce9-22e31f2f1f0e@linux.alibaba.com>
Date:   Fri, 26 May 2023 10:15:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        lhenriques@suse.de, junxiao.bi@oracle.com, jlbec@evilplan.org,
        ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com
References: <20230525205556.680DCC433EF@smtp.kernel.org>
 <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
 <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 5/26/23 10:05 AM, Andrew Morton wrote:
> On Fri, 26 May 2023 09:36:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Hi Andrew,
>>
>> There is an updated version v2, which describe more clearly about the
>> case:
>> https://lore.kernel.org/ocfs2-devel/e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com/T/#u
> 
> Sigh.  Thanks.
> 
> As you can see from the above link, the email never hit ocfs2-devel and
> never hit my inbox.  I'll piece it together from your reply.
> 

Sorry for the inconvenience. I quote the updated description below:

"
It's trivial to trigger a use-after-free bug in the ocfs2 quotas code using
fstest generic/452.  After a read-only remount, quotas are suspended and
ocfs2_mem_dqinfo is freed through ->ocfs2_local_free_info().  When unmounting
the filesystem, an UAF access to the oinfo will eventually cause a crash.

BUG: KASAN: slab-use-after-free in timer_delete+0x54/0xc0
Read of size 8 at addr ffff8880389a8208 by task umount/669
...
Call Trace:
 <TASK>
 ...
 timer_delete+0x54/0xc0
 try_to_grab_pending+0x31/0x230
 __cancel_work_timer+0x6c/0x270
 ocfs2_disable_quotas.isra.0+0x3e/0xf0 [ocfs2]
 ocfs2_dismount_volume+0xdd/0x450 [ocfs2]
 generic_shutdown_super+0xaa/0x280
 kill_block_super+0x46/0x70
 deactivate_locked_super+0x4d/0xb0
 cleanup_mnt+0x135/0x1f0
 ...
 </TASK>

Allocated by task 632:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x8b/0x90
 ocfs2_local_read_info+0xe3/0x9a0 [ocfs2]
 dquot_load_quota_sb+0x34b/0x680
 dquot_load_quota_inode+0xfe/0x1a0
 ocfs2_enable_quotas+0x190/0x2f0 [ocfs2]
 ocfs2_fill_super+0x14ef/0x2120 [ocfs2]
 mount_bdev+0x1be/0x200
 legacy_get_tree+0x6c/0xb0
 vfs_get_tree+0x3e/0x110
 path_mount+0xa90/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 650:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0xf9/0x150
 __kmem_cache_free+0x89/0x180
 ocfs2_local_free_info+0x2ba/0x3f0 [ocfs2]
 dquot_disable+0x35f/0xa70
 ocfs2_susp_quotas.isra.0+0x159/0x1a0 [ocfs2]
 ocfs2_remount+0x150/0x580 [ocfs2]
 reconfigure_super+0x1a5/0x3a0
 path_mount+0xc8a/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
"

> The ocfs2-devel list is really bad.  Can we move to a vger list?  Or
> get some maintenance work done on ocfs2-devel?
> 

I see. It seems something wrong with ocfs2-devel. But I'm not an
administrator of it:(

Thanks,
Joseph
