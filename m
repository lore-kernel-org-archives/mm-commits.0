From: akpm@linux-foundation.org
Subject: +
 documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 16:22:53 -0700
Message-ID: <538d074d.zNhcZuGKz51ADwiS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFBXWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 19:22:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, dvlasenk@redhat.com

Subject: + documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch added to -mm tree
To: dvlasenk@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 16:22:53 -0700


The patch titled
     Subject: Documentation/sysctl/vm.txt: clarify vfs_cache_pressure description
has been added to the -mm tree.  Its filename is
     documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Documentation/sysctl/vm.txt: clarify vfs_cache_pressure description

Existing description is worded in a way which almost encourages setting of
vfs_cache_pressure above 100, possibly way above it.

Users are left in a dark what this numeric value is - an int?  a
percentage?  what the scale is?

As a result, we are getting reports about noticeable performance
degradation from users who have set vfs_cache_pressure to ridiculously
high values - because they thought there is no downside to it.

Via code inspection it's obvious that this value is treated as a
percentage.  This patch changes text to reflect this fact, and adds a
cautionary paragraph advising against setting vfs_cache_pressure sky high.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description
+++ a/Documentation/sysctl/vm.txt
@@ -746,8 +746,8 @@ Changing this takes effect whenever an a
 vfs_cache_pressure
 ------------------
 
-Controls the tendency of the kernel to reclaim the memory which is used for
-caching of directory and inode objects.
+This percentage value controls the tendency of the kernel to reclaim
+the memory which is used for caching of directory and inode objects.
 
 At the default value of vfs_cache_pressure=100 the kernel will attempt to
 reclaim dentries and inodes at a "fair" rate with respect to pagecache and
@@ -757,6 +757,11 @@ never reclaim dentries and inodes due to
 lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
+Increasing vfs_cache_pressure significantly beyond 100 may have negative
+performance impact. Reclaim code needs to take various locks to find freeable
+directory and inode objects. With vfs_cache_pressure=1000, it will look for
+ten times more freeable objects than there are.
+
 ==============================================================
 
 zone_reclaim_mode:
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

documentation-sysctl-vmtxt-clarify-vfs_cache_pressure-description.patch
linux-next.patch

