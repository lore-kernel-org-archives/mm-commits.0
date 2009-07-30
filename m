From: akpm@linux-foundation.org
Subject: [failures] documentation-strncpy-does-not-null-terminate-string.patch removed from -mm tree
Date: Thu, 30 Jul 2009 02:27:52 -0700
Message-ID: <200907300927.n6U9Rqbw024776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbZG3J22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 05:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/: strncpy does not null terminate string
has been removed from the -mm tree.  Its filename was
     documentation-strncpy-does-not-null-terminate-string.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

With `sizeof(string) - 1` strncpy() will null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c                 |    2 +-
 Documentation/input/joystick-api.txt                 |    2 +-
 Documentation/networking/packet_mmap.txt             |    2 +-
 Documentation/networking/timestamping/timestamping.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/accounting/getdelays.c~documentation-strncpy-does-not-null-terminate-string Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/accounting/getdelays.c
@@ -303,7 +303,7 @@ int main(int argc, char *argv[])
 				err(1, "Invalid rcv buf size\n");
 			break;
 		case 'm':
-			strncpy(cpumask, optarg, sizeof(cpumask));
+			strlcpy(cpumask, optarg, sizeof(cpumask));
 			maskset = 1;
 			printf("cpumask %s maskset %d\n", cpumask, maskset);
 			break;
diff -puN Documentation/input/joystick-api.txt~documentation-strncpy-does-not-null-terminate-string Documentation/input/joystick-api.txt
--- a/Documentation/input/joystick-api.txt~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/input/joystick-api.txt
@@ -230,7 +230,7 @@ possible overrun should the name be too 
 
 	char name[128];
 	if (ioctl(fd, JSIOCGNAME(sizeof(name)), name) < 0)
-		strncpy(name, "Unknown", sizeof(name));
+		strlcpy(name, "Unknown", sizeof(name));
 	printf("Name: %s\n", name);
 
 
diff -puN Documentation/networking/packet_mmap.txt~documentation-strncpy-does-not-null-terminate-string Documentation/networking/packet_mmap.txt
--- a/Documentation/networking/packet_mmap.txt~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/networking/packet_mmap.txt
@@ -148,7 +148,7 @@ As capture, each frame contains two part
  struct ifreq s_ifr;
  ...
 
- strncpy (s_ifr.ifr_name, "eth0", sizeof(s_ifr.ifr_name));
+ strlcpy (s_ifr.ifr_name, "eth0", sizeof(s_ifr.ifr_name));
 
  /* get interface index of eth0 */
  ioctl(this->socket, SIOCGIFINDEX, &s_ifr);
diff -puN Documentation/networking/timestamping/timestamping.c~documentation-strncpy-does-not-null-terminate-string Documentation/networking/timestamping/timestamping.c
--- a/Documentation/networking/timestamping/timestamping.c~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/networking/timestamping/timestamping.c
@@ -374,12 +374,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	strlcpy(device.ifr_name, interface, sizeof(device.ifr_name));
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	strlcpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(&hwconfig));
 	hwconfig.tx_type =
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
irda-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
libertas-fix-read-outside-array-bounds.patch
libertas-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

