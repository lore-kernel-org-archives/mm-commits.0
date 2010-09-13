From: akpm@linux-foundation.org
Subject: + documentation-timers-hpet_examplec-add-supporting-info-for-hpet_example.patch added to -mm tree
Date: Mon, 13 Sep 2010 16:30:04 -0700
Message-ID: <201009132330.o8DNU4kS027572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab0IMXaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 19:30:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinderlinux@gmail.com, clemens@ladisch.de, jaswinderrajput@gmail.com, johnstul@us.ibm.com, tglx@linutronix.de, venki@google.com


The patch titled
     Documentation/timers/hpet_example.c: add supporting info for hpet_example
has been added to the -mm tree.  Its filename is
     documentation-timers-hpet_examplec-add-supporting-info-for-hpet_example.patch

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
Subject: Documentation/timers/hpet_example.c: add supporting info for hpet_example
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>

$./hpet_example info /dev/hpet
-hpet: executing info
hpet_info: hi_irqfreq 0x0 hi_flags 0x0 hi_hpet 0 hi_timer 2

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: "Venkatesh Pallipadi (Venki)" <venki@google.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/timers/hpet_example.c |   27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN Documentation/timers/hpet_example.c~documentation-timers-hpet_examplec-add-supporting-info-for-hpet_example Documentation/timers/hpet_example.c
--- a/Documentation/timers/hpet_example.c~documentation-timers-hpet_examplec-add-supporting-info-for-hpet_example
+++ a/Documentation/timers/hpet_example.c
@@ -97,6 +97,33 @@ hpet_open_close(int argc, const char **a
 void
 hpet_info(int argc, const char **argv)
 {
+	struct hpet_info	info;
+	int			fd;
+
+	if (argc != 1) {
+		fprintf(stderr, "hpet_info: device-name\n");
+		return;
+	}
+
+	fd = open(argv[0], O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "hpet_info: open of %s failed\n", argv[0]);
+		return;
+	}
+
+	if (ioctl(fd, HPET_INFO, &info) < 0) {
+		fprintf(stderr, "hpet_info: failed to get info\n");
+		goto out;
+	}
+
+	fprintf(stderr, "hpet_info: hi_irqfreq 0x%lx hi_flags 0x%lx ",
+		info.hi_ireqfreq, info.hi_flags);
+	fprintf(stderr, "hi_hpet %d hi_timer %d\n",
+		info.hi_hpet, info.hi_timer);
+
+out:
+	close(fd);
+	return;
 }
 
 void
_

Patches currently in -mm which might be from jaswinderlinux@gmail.com are

hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch
documentation-timers-hpet_examplec-add-supporting-info-for-hpet_example.patch

