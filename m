From: akpm@linux-foundation.org
Subject: + arch-powerpc-platforms-pseries-add-missing-of_node_put.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:08:31 -0800
Message-ID: <200801120108.m0C18VdT007046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763029AbYALBIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:08:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     arch/powerpc/platforms/pseries: Add missing of_node_put
has been added to the -mm tree.  Its filename is
     arch-powerpc-platforms-pseries-add-missing-of_node_put.patch

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
Subject: arch/powerpc/platforms/pseries: Add missing of_node_put
From: Julia Lawall <julia@diku.dk>


Of_get_parent and of_find_compatible_node do an of_node_get, and thus a
corresponding of_code_put is needed in the error case.

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

 arch/powerpc/platforms/pseries/reconfig.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/platforms/pseries/reconfig.c~arch-powerpc-platforms-pseries-add-missing-of_node_put arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~arch-powerpc-platforms-pseries-add-missing-of_node_put
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -167,6 +167,7 @@ static int pSeries_reconfig_remove_node(
 
 	if ((child = of_get_next_child(np, NULL))) {
 		of_node_put(child);
+		of_node_put(parent);
 		return -EBUSY;
 	}
 
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
