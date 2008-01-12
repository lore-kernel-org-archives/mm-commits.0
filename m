From: akpm@linux-foundation.org
Subject: + arch-powerpc-sysdev-add-missing-of_node_put.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:08:34 -0800
Message-ID: <200801120108.m0C18Y0k007049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087AbYALBIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:08:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     arch/powerpc/sysdev: Add missing of_node_put
has been added to the -mm tree.  Its filename is
     arch-powerpc-sysdev-add-missing-of_node_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/powerpc/sysdev: Add missing of_node_put
From: Julia Lawall <julia@diku.dk>


The functions of_find_compatible_node and of_find_node_by_type both call
of_node_get on their result.  So any error handling code thereafter should
call of_node_put(np).  This is taken care of in the case where there is a goto
out, but not when there is a direct return.

The function irq_alloc_host puts np into the returned structure, which is
stored in the global variable mpc8xx_pic_host, so the reference count
should be set for the lifetime of that variable.  The current solution ups
the reference count again in the argument to irq_alloc_host so that it can
be decremented on the way out.  This seems a bit unnecessary, and also
doesn't work in the case where irq_alloc_host fails, because then the
reference count only goes does by one, whereas it should go down by two.  A
better solution is to not increment the reference count in the argument to
irq_alloc_host and only decrement it on the way out in an error case.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = \(of_get_parent\|of_find_compatible_node\)(...);
  if (E == NULL) S
  ... when != of_node_put(...,(T1)E,...)
      when != if (E != NULL) { ... of_node_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != of_node_put(...,(T2)E,...)
        when != if (E != NULL) { ... of_node_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/mpc8xx_pic.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/sysdev/mpc8xx_pic.c~arch-powerpc-sysdev-add-missing-of_node_put arch/powerpc/sysdev/mpc8xx_pic.c
--- a/arch/powerpc/sysdev/mpc8xx_pic.c~arch-powerpc-sysdev-add-missing-of_node_put
+++ a/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -175,15 +175,19 @@ int mpc8xx_pic_init(void)
 		goto out;
 
 	siu_reg = ioremap(res.start, res.end - res.start + 1);
-	if (siu_reg == NULL)
-		return -EINVAL;
+	if (siu_reg == NULL) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	mpc8xx_pic_host = irq_alloc_host(of_node_get(np), IRQ_HOST_MAP_LINEAR,
+	mpc8xx_pic_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
 					 64, &mpc8xx_pic_host_ops, 64);
 	if (mpc8xx_pic_host == NULL) {
 		printk(KERN_ERR "MPC8xx PIC: failed to allocate irq host!\n");
 		ret = -ENOMEM;
+		goto out;
 	}
+	return 0;
 
 out:
 	of_node_put(np);
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
git-agpgart.patch
git-powerpc.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
drivers-media-common-add-missing-video_device_release.patch
git-input.patch
drivers-pcmcia-add-missing-iounmap.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
