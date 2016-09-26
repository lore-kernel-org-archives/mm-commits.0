From: akpm@linux-foundation.org
Subject: + scripts-recordmcountc-account-for-softirqentrytext.patch added
 to -mm tree
Date: Mon, 26 Sep 2016 16:19:02 -0700
Message-ID: <57e9ace6.2n9jdHQzyuIJtRah%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbcIZXTD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, rostedt@goodmis.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/recordmcount.c: account for .softirqentry.text
has been added to the -mm tree.  Its filename is
     scripts-recordmcountc-account-for-softirqentrytext.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-recordmcountc-account-for-softirqentrytext.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-recordmcountc-account-for-softirqentrytext.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: scripts/recordmcount.c: account for .softirqentry.text

be7635e7287e ("arch, ftrace: for KASAN put hard/soft IRQ entries into
separate sections") added .softirqentry.text section, but it was not added
to recordmcount.  So functions in the section are untracable.  Add the
section to scripts/recordmcount.c and scripts/recordmcount.pl.

Fixes: be7635e7287e ("arch, ftrace: for KASAN put hard/soft IRQ entries into separate sections")
Link: http://lkml.kernel.org/r/1474902626-73468-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Steve Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/recordmcount.c  |    1 +
 scripts/recordmcount.pl |    1 +
 2 files changed, 2 insertions(+)

diff -puN scripts/recordmcount.c~scripts-recordmcountc-account-for-softirqentrytext scripts/recordmcount.c
--- a/scripts/recordmcount.c~scripts-recordmcountc-account-for-softirqentrytext
+++ a/scripts/recordmcount.c
@@ -363,6 +363,7 @@ is_mcounted_section_name(char const *con
 		strcmp(".sched.text",    txtname) == 0 ||
 		strcmp(".spinlock.text", txtname) == 0 ||
 		strcmp(".irqentry.text", txtname) == 0 ||
+		strcmp(".softirqentry.text", txtname) == 0 ||
 		strcmp(".kprobes.text", txtname) == 0 ||
 		strcmp(".text.unlikely", txtname) == 0;
 }
diff -puN scripts/recordmcount.pl~scripts-recordmcountc-account-for-softirqentrytext scripts/recordmcount.pl
--- a/scripts/recordmcount.pl~scripts-recordmcountc-account-for-softirqentrytext
+++ a/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".softirqentry.text" => 1,
      ".kprobes.text" => 1,
      ".text.unlikely" => 1,
 );
_

Patches currently in -mm which might be from dvyukov@google.com are

scripts-recordmcountc-account-for-softirqentrytext.patch

