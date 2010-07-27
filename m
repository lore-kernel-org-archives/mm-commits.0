From: akpm@linux-foundation.org
Subject: + timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch added to -mm tree
Date: Tue, 27 Jul 2010 16:22:02 -0700
Message-ID: <201007272322.o6RNM2le011142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab0G0XWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jul 2010 19:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timer_list: remove alignment padding on 64 bit when CONFIG_TIMER_STATS
has been added to the -mm tree.  Its filename is
     timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch

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
Subject: timer_list: remove alignment padding on 64 bit when CONFIG_TIMER_STATS
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder structure timer_list to remove 8 bytes of alignment padding on 64
bit builds when CONFIG_TIMER_STATS is selected.

timer_list is widely used across the kernel so many structures will
benefit and shrink in size.

For example, with my config on x86_64
	per_cpu_dm_data shrinks from 136 to 128 bytes
and
	ahci_port_priv shrinks from 1032 to 968 bytes.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/timer.h~timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats include/linux/timer.h
--- a/include/linux/timer.h~timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats
+++ a/include/linux/timer.h
@@ -24,9 +24,9 @@ struct timer_list {
 	int slack;
 
 #ifdef CONFIG_TIMER_STATS
+	int start_pid;
 	void *start_site;
 	char start_comm[16];
-	int start_pid;
 #endif
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch

