From: akpm@linux-foundation.org
Subject: + taskstats-check-nla_reserve-return.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:25:14 -0700
Message-ID: <20120724212515.016AB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49155 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2GXVZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:25:17 -0400
Received: by bkcjc3 with SMTP id jc3so833bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:25:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, rucsoftsec@gmail.com


The patch titled
     Subject: taskstats: check nla_reserve() return
has been added to the -mm tree.  Its filename is
     taskstats-check-nla_reserve-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: taskstats: check nla_reserve() return

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44621

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/taskstats.c~taskstats-check-nla_reserve-return kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-check-nla_reserve-return
+++ a/kernel/taskstats.c
@@ -436,6 +436,11 @@ static int cgroupstats_user_cmd(struct s
 
 	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
 				sizeof(struct cgroupstats));
+	if (na == NULL) {
+		rc = -EMSGSIZE;
+		goto err;
+	}
+
 	stats = nla_data(na);
 	memset(stats, 0, sizeof(*stats));
 
_
Subject: Subject: taskstats: check nla_reserve() return

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch
drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch
drivers-media-video-ov9640c-fix-missing-break.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch
drivers-message-i2o-i2o_configc-bound-allocation.patch
taskstats-check-nla_reserve-return.patch

