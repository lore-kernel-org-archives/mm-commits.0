From: akpm@linux-foundation.org
Subject: + add-kerneldoc-documentation-for-new-printk-format-extensions.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:44:56 -0700
Message-ID: <200810102344.m9ANiunc017936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYJJXpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     Add kerneldoc documentation for new printk format extensions
has been added to the -mm tree.  Its filename is
     add-kerneldoc-documentation-for-new-printk-format-extensions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add kerneldoc documentation for new printk format extensions
From: Andi Kleen <andi@firstfloor.org>

Add documentation in kerneldoc for new printk format extensions

This patch documents the new %pS/%pF options in printk in kernel doc.

Hope I didn't miss any other extension.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 ++
 lib/vsprintf.c  |   12 ++++++++++++
 2 files changed, 14 insertions(+)

diff -puN kernel/printk.c~add-kerneldoc-documentation-for-new-printk-format-extensions kernel/printk.c
--- a/kernel/printk.c~add-kerneldoc-documentation-for-new-printk-format-extensions
+++ a/kernel/printk.c
@@ -593,6 +593,8 @@ static int have_callable_console(void)
  *
  * See also:
  * printf(3)
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 
 asmlinkage int printk(const char *fmt, ...)
diff -puN lib/vsprintf.c~add-kerneldoc-documentation-for-new-printk-format-extensions lib/vsprintf.c
--- a/lib/vsprintf.c~add-kerneldoc-documentation-for-new-printk-format-extensions
+++ a/lib/vsprintf.c
@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
+ * This function follows C99 vsnprintf, but has some extensions:
+ * %pS output the name of a text symbol
+ * %pF output the name of a function pointer
+ *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
@@ -806,6 +810,8 @@ EXPORT_SYMBOL(vsnprintf);
  *
  * Call this function if you are already dealing with a va_list.
  * You probably want scnprintf() instead.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
@@ -828,6 +834,8 @@ EXPORT_SYMBOL(vscnprintf);
  * generated for the given input, excluding the trailing null,
  * as per ISO C99.  If the return is greater than or equal to
  * @size, the resulting string is truncated.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int snprintf(char * buf, size_t size, const char *fmt, ...)
 {
@@ -877,6 +885,8 @@ EXPORT_SYMBOL(scnprintf);
  *
  * Call this function if you are already dealing with a va_list.
  * You probably want sprintf() instead.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int vsprintf(char *buf, const char *fmt, va_list args)
 {
@@ -894,6 +904,8 @@ EXPORT_SYMBOL(vsprintf);
  * The function returns the number of characters written
  * into @buf. Use snprintf() or scnprintf() in order to avoid
  * buffer overflows.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
  */
 int sprintf(char * buf, const char *fmt, ...)
 {
_

Patches currently in -mm which might be from andi@firstfloor.org are

git-tip.patch
git-pci.patch
git-ext4.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
misdn-misc-timerdev-fixes-fix.patch
make-taint-bit-reliable-v3.patch
make-taint-bit-reliable-v3-fix.patch
taint-fix-kernel-doc.patch
submittingpatches-add-a-reference-to-andis-ols-paper.patch
add-kerneldoc-documentation-for-new-printk-format-extensions.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
acpi-use-bcd2bin-bin2bcd.patch
profile-likely-unlikely-macros.patch

