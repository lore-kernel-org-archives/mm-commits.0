From: akpm@linux-foundation.org
Subject: + kallsyms-tracing-output-more-proper-symbol-name.patch added to -mm tree
Date: Fri, 13 Mar 2009 12:40:20 -0700
Message-ID: <200903131940.n2DJeLXR017973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbZCMTpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 15:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, fweisbec@gmail.com, mingo@elte.hu, pmarques@grupopie.com, sam@ravnborg.org, srostedt@redhat.com


The patch titled
     kallsyms, tracing: output more proper symbol name
has been added to the -mm tree.  Its filename is
     kallsyms-tracing-output-more-proper-symbol-name.patch

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
Subject: kallsyms, tracing: output more proper symbol name


Impact: bugfix, output reliable result

Debug tools(dump_stack(), ftrace...) are like to print out symbols.  But
it is always print out the first aliased symbol.(Aliased symbols are
symbols with the same address), and the first aliased symbol is sometime
not proper.

# echo function_graph > current_tracer
# cat trace
......
 1)   1.923 us    |    select_nohz_load_balancer();
 1) + 76.692 us   |  }
 1)               |  default_idle() {
 1)   ==========> |    __irqentry_text_start() {
 1)   0.000 us    |      native_apic_mem_write();
 1)               |      irq_enter() {
 1)   0.000 us    |        idle_cpu();
 1)               |        tick_check_idle() {
 1)   0.000 us    |          tick_check_oneshot_broadcast();
 1)               |          tick_nohz_stop_idle() {
......

It's very embarrassing, it outputs "__irqentry_text_start()", actually, it
should output "smp_apic_timer_interrupt()".  (these two symbol are the
same address, but "__irqentry_text_start" is deemed to the first aliased
symbol by scripts/kallsyms)

This patch puts symbols like "__irqentry_text_start" to the second aliased
symbols.  And a more proper symbol name becomes the first.

Aliased symbols mostly come from linker script.  The solution is guessing
"is this symbol defined in linker script", the symbols defined in linker
script will not become the first aliased symbol.

And if symbols are found to be equal in this "linker script provided"
criteria, symbols are sorted by the number of prefix underscores.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paulo Marques <pmarques@grupopie.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff -puN scripts/kallsyms.c~kallsyms-tracing-output-more-proper-symbol-name scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-tracing-output-more-proper-symbol-name
+++ a/scripts/kallsyms.c
@@ -500,6 +500,51 @@ static void optimize_token_table(void)
 	optimize_result();
 }
 
+/* guess for "linker script provide" symbol */
+static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
+{
+	const char *symbol = (char *)se->sym + 1;
+	int len = se->len - 1;
+
+	if (len < 8)
+		return 0;
+
+	if (symbol[0] != '_' || symbol[1] != '_')
+		return 0;
+
+	/* __start_XXXXX */
+	if (!memcmp(symbol + 2, "start_", 6))
+		return 1;
+
+	/* __stop_XXXXX */
+	if (!memcmp(symbol + 2, "stop_", 5))
+		return 1;
+
+	/* __end_XXXXX */
+	if (!memcmp(symbol + 2, "end_", 4))
+		return 1;
+
+	/* __XXXXX_start */
+	if (!memcmp(symbol + len - 6, "_start", 6))
+		return 1;
+
+	/* __XXXXX_end */
+	if (!memcmp(symbol + len - 4, "_end", 4))
+		return 1;
+
+	return 0;
+}
+
+static int prefix_underscores_count(const char *str)
+{
+	const char *tail = str;
+
+	while (*tail == '_')
+		tail++;
+
+	return tail - str;
+}
+
 static int compare_symbols(const void *a, const void *b)
 {
 	const struct sym_entry *sa;
@@ -521,6 +566,18 @@ static int compare_symbols(const void *a
 	if (wa != wb)
 		return wa - wb;
 
+	/* sort by "linker script provide" type */
+	wa = may_be_linker_script_provide_symbol(sa);
+	wb = may_be_linker_script_provide_symbol(sb);
+	if (wa != wb)
+		return wa - wb;
+
+	/* sort by the number of prefix underscores */
+	wa = prefix_underscores_count((const char *)sa->sym + 1);
+	wb = prefix_underscores_count((const char *)sb->sym + 1);
+	if (wa != wb)
+		return wa - wb;
+
 	/* sort by initial order, so that other symbols are left undisturbed */
 	return sa->start_pos - sb->start_pos;
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
kallsyms-tracing-output-more-proper-symbol-name.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
workqueue-avoid-recursion-in-run_workqueue.patch
cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch

