From: akpm@linux-foundation.org
Subject: + pktcdvd-reduce-stack-consumption.patch added to -mm tree
Date: Mon, 25 Feb 2008 12:28:07 -0800
Message-ID: <200802252028.m1PKSxHq018067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYBYU3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 15:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petero2@telia.com, nix@esperi.org.uk


The patch titled
     pktcdvd: reduce stack consumption
has been added to the -mm tree.  Its filename is
     pktcdvd-reduce-stack-consumption.patch

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
Subject: pktcdvd: reduce stack consumption
From: Peter Osterlund <petero2@telia.com>

On my system, pkt_open() consumes 584 bytes because the compiler decides to
inline lots of functions that would not normally be part of long call chains. 
The following patch fixes that problem on my system.

Signed-off-by: Peter Osterlund <petero2@telia.com>
Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-reduce-stack-consumption drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-reduce-stack-consumption
+++ a/drivers/block/pktcdvd.c
@@ -849,7 +849,8 @@ static int pkt_flush_cache(struct pktcdv
 /*
  * speed is given as the normal factor, e.g. 4 for 4x
  */
-static int pkt_set_speed(struct pktcdvd_device *pd, unsigned write_speed, unsigned read_speed)
+static noinline_for_stack int pkt_set_speed(struct pktcdvd_device *pd,
+				unsigned write_speed, unsigned read_speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -1776,7 +1777,8 @@ static int pkt_get_track_info(struct pkt
 	return pkt_generic_packet(pd, &cgc);
 }
 
-static int pkt_get_last_written(struct pktcdvd_device *pd, long *last_written)
+static noinline_for_stack int pkt_get_last_written(struct pktcdvd_device *pd,
+						long *last_written)
 {
 	disc_information di;
 	track_information ti;
@@ -1813,7 +1815,7 @@ static int pkt_get_last_written(struct p
 /*
  * write mode select package based on pd->settings
  */
-static int pkt_set_write_settings(struct pktcdvd_device *pd)
+static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -1972,7 +1974,7 @@ static int pkt_writable_disc(struct pktc
 	return 1;
 }
 
-static int pkt_probe_settings(struct pktcdvd_device *pd)
+static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	unsigned char buf[12];
@@ -2071,7 +2073,8 @@ static int pkt_probe_settings(struct pkt
 /*
  * enable/disable write caching on drive
  */
-static int pkt_write_caching(struct pktcdvd_device *pd, int set)
+static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
+						int set)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2116,7 +2119,8 @@ static int pkt_lock_door(struct pktcdvd_
 /*
  * Returns drive maximum write speed
  */
-static int pkt_get_max_speed(struct pktcdvd_device *pd, unsigned *write_speed)
+static noinline_for_stack int pkt_get_max_speed(struct pktcdvd_device *pd,
+						unsigned *write_speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2177,7 +2181,8 @@ static char us_clv_to_speed[16] = {
 /*
  * reads the maximum media speed from ATIP
  */
-static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
+static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
+						unsigned *speed)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
@@ -2249,7 +2254,7 @@ static int pkt_media_speed(struct pktcdv
 	}
 }
 
-static int pkt_perform_opc(struct pktcdvd_device *pd)
+static noinline_for_stack int pkt_perform_opc(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	struct request_sense sense;
_

Patches currently in -mm which might be from petero2@telia.com are

pktcdvd-reduce-stack-consumption.patch
