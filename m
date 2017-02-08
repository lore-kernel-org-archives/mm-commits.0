From: akpm@linux-foundation.org
Subject: + mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch added to -mm tree
Date: Wed, 08 Feb 2017 14:21:50 -0800
Message-ID: <589b99fe.f+CmcE2tChvXPcmo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdBHWWG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, aquini@redhat.com, gi-oh.kim@profitbricks.com, guohanjun@huawei.com, jasowang@redhat.com, koct9i@gmail.com, mhocko@kernel.org, minchan@kernel.org, mst@redhat.com, qiuxishi@huawei.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm balloon: umount balloon_mnt when removing vb device
has been added to the -mm tree.  Its filename is
     mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm balloon: umount balloon_mnt when removing vb device

With CONFIG_BALLOON_COMPACTION=y the kernel will mount balloon_mnt for
balloon page migration when we probe a virtio_balloon device.  However we
do not unmount it when removing the device.  Fix this.

Fixes: b1123ea6d3b3 ("mm: balloon: use general non-lru movable page feature")
Link: http://lkml.kernel.org/r/1486531318-35189-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/virtio/virtio_balloon.c~mm-balloon-umount-balloon_mnt-when-remove-vb-device drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-balloon-umount-balloon_mnt-when-remove-vb-device
+++ a/drivers/virtio/virtio_balloon.c
@@ -615,8 +615,12 @@ static void virtballoon_remove(struct vi
 	cancel_work_sync(&vb->update_balloon_stats_work);
 
 	remove_common(vb);
+#ifdef CONFIG_BALLOON_COMPACTION
 	if (vb->vb_dev_info.inode)
 		iput(vb->vb_dev_info.inode);
+
+	kern_unmount(balloon_mnt);
+#endif
 	kfree(vb);
 }
 
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-return-int-type-v6.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch
mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch

