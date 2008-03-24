From: akpm@linux-foundation.org
Subject: + kbuild-move-files-that-dont-check-__kernel__.patch added to -mm tree
Date: Mon, 24 Mar 2008 14:53:49 -0700
Message-ID: <200803242153.m2OLrnq2027255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbYCXVyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org


The patch titled
     kbuild: move files that don't check __KERNEL__
has been added to the -mm tree.  Its filename is
     kbuild-move-files-that-dont-check-__kernel__.patch

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
Subject: kbuild: move files that don't check __KERNEL__
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Move files that don't check __KERNEL__ from unifdef-y to header-y.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/Kbuild~kbuild-move-files-that-dont-check-__kernel__ include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-move-files-that-dont-check-__kernel__
+++ a/include/linux/Kbuild
@@ -20,6 +20,7 @@ header-y += affs_hardblocks.h
 header-y += aio_abi.h
 header-y += arcfb.h
 header-y += atmapi.h
+header-y += atmarp.h
 header-y += atmbr2684.h
 header-y += atmclip.h
 header-y += atm_eni.h
@@ -48,6 +49,7 @@ header-y += coff.h
 header-y += comstats.h
 header-y += const.h
 header-y += cgroupstats.h
+header-y += cramfs_fs.h
 header-y += cycx_cfm.h
 header-y += dlmconstants.h
 header-y += dlm_device.h
@@ -70,10 +72,12 @@ header-y += firewire-constants.h
 header-y += fuse.h
 header-y += genetlink.h
 header-y += gen_stats.h
+header-y += gfs2_ondisk.h
 header-y += gigaset_dev.h
 header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
+header-y += if_addrlabel.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
 header-y += if_cablemodem.h
@@ -90,6 +94,7 @@ header-y += if_tunnel.h
 header-y += in6.h
 header-y += in_route.h
 header-y += ioctl.h
+header-y += ip6_tunnel.h
 header-y += ipmi_msgdefs.h
 header-y += ipsec.h
 header-y += ipx.h
@@ -152,11 +157,14 @@ header-y += toshiba.h
 header-y += udf_fs_i.h
 header-y += ultrasound.h
 header-y += un.h
+header-y += unistd.h
 header-y += utime.h
 header-y += veth.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
+header-y += virtio_blk.h
+header-y += virtio_net.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -165,7 +173,6 @@ unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
-unifdef-y += atmarp.h
 unifdef-y += atmdev.h
 unifdef-y += atm.h
 unifdef-y += atm_tcp.h
@@ -181,7 +188,6 @@ unifdef-y += cm4000_cs.h
 unifdef-y += cn_proc.h
 unifdef-y += coda.h
 unifdef-y += connector.h
-unifdef-y += cramfs_fs.h
 unifdef-y += cuda.h
 unifdef-y += cyclades.h
 unifdef-y += dccp.h
@@ -205,7 +211,6 @@ unifdef-y += futex.h
 unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
-unifdef-y += gfs2_ondisk.h
 unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
@@ -217,7 +222,6 @@ unifdef-y += i2c-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
-unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h
@@ -243,7 +247,6 @@ unifdef-y += ipc.h
 unifdef-y += ipmi.h
 unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
-unifdef-y += ip6_tunnel.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h
@@ -338,14 +341,11 @@ unifdef-y += types.h
 unifdef-y += udp.h
 unifdef-y += uinput.h
 unifdef-y += uio.h
-unifdef-y += unistd.h
 unifdef-y += usbdevice_fs.h
 unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
 unifdef-y += virtio_config.h
-unifdef-y += virtio_blk.h
-unifdef-y += virtio_net.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-ieee1394.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
git-sparc64.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
kbuild-move-files-that-dont-check-__kernel__.patch

