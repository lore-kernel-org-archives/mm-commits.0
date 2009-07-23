From: akpm@linux-foundation.org
Subject: + documentation-strncpy-does-not-null-terminate-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:43:45 -0700
Message-ID: <200907232043.n6NKhjTV022280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbZGWUnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, randy.dunlap@oracle.com


The patch titled
     Documentation/: strncpy does not null terminate string
has been added to the -mm tree.  Its filename is
     documentation-strncpy-does-not-null-terminate-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
+			strncpy(cpumask, optarg, sizeof(cpumask) - 1);
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
+		strncpy(name, "Unknown", sizeof(name) - 1);
 	printf("Name: %s\n", name);
 
 
diff -puN Documentation/networking/packet_mmap.txt~documentation-strncpy-does-not-null-terminate-string Documentation/networking/packet_mmap.txt
--- a/Documentation/networking/packet_mmap.txt~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/networking/packet_mmap.txt
@@ -148,7 +148,7 @@ As capture, each frame contains two part
  struct ifreq s_ifr;
  ...
 
- strncpy (s_ifr.ifr_name, "eth0", sizeof(s_ifr.ifr_name));
+ strncpy (s_ifr.ifr_name, "eth0", sizeof(s_ifr.ifr_name) - 1);
 
  /* get interface index of eth0 */
  ioctl(this->socket, SIOCGIFINDEX, &s_ifr);
diff -puN Documentation/networking/timestamping/timestamping.c~documentation-strncpy-does-not-null-terminate-string Documentation/networking/timestamping/timestamping.c
--- a/Documentation/networking/timestamping/timestamping.c~documentation-strncpy-does-not-null-terminate-string
+++ a/Documentation/networking/timestamping/timestamping.c
@@ -374,12 +374,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	strncpy(device.ifr_name, interface, sizeof(device.ifr_name) - 1);
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name) - 1);
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(&hwconfig));
 	hwconfig.tx_type =
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

