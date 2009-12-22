From: akpm@linux-foundation.org
Subject: + documentation-update-ftrace-designtxt.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:41:51 -0800
Message-ID: <200912222241.nBMMfp0K028683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZLVWmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mel@csn.ul.ie, rostedt@goodmis.org


The patch titled
     Documentation: update ftrace-design.txt
has been added to the -mm tree.  Its filename is
     documentation-update-ftrace-designtxt.patch

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
Subject: Documentation: update ftrace-design.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct grammos.  Spell out words.  Add missing words.  Consistent use of
"mcount()" function name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/ftrace-design.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN Documentation/trace/ftrace-design.txt~documentation-update-ftrace-designtxt Documentation/trace/ftrace-design.txt
--- a/Documentation/trace/ftrace-design.txt~documentation-update-ftrace-designtxt
+++ a/Documentation/trace/ftrace-design.txt
@@ -53,14 +53,14 @@ size of the mcount call that is embedded
 For example, if the function foo() calls bar(), when the bar() function calls
 mcount(), the arguments mcount() will pass to the tracer are:
 	"frompc" - the address bar() will use to return to foo()
-	"selfpc" - the address bar() (with _mcount() size adjustment)
+	"selfpc" - the address bar() (with mcount() size adjustment)
 
 Also keep in mind that this mcount function will be called *a lot*, so
 optimizing for the default case of no tracer will help the smooth running of
 your system when tracing is disabled.  So the start of the mcount function is
-typically the bare min with checking things before returning.  That also means
-the code flow should usually kept linear (i.e. no branching in the nop case).
-This is of course an optimization and not a hard requirement.
+typically the bare minimum with checking things before returning.  That also
+means the code flow should usually be kept linear (i.e. no branching in the nop
+case).  This is of course an optimization and not a hard requirement.
 
 Here is some pseudo code that should help (these functions should actually be
 implemented in assembly):
@@ -131,10 +131,10 @@ some functions to save (hijack) and rest
 
 The mcount function should check the function pointers ftrace_graph_return
 (compare to ftrace_stub) and ftrace_graph_entry (compare to
-ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
+ftrace_graph_entry_stub).  If either of those is not set to the relevant stub
 function, call the arch-specific function ftrace_graph_caller which in turn
 calls the arch-specific function prepare_ftrace_return.  Neither of these
-function names are strictly required, but you should use them anyways to stay
+function names is strictly required, but you should use them anyway to stay
 consistent across the architecture ports -- easier to compare & contrast
 things.
 
@@ -144,7 +144,7 @@ but the first argument should be a point
 located on the stack.  This allows the function to hijack the return address
 temporarily to have it point to the arch-specific function return_to_handler.
 That function will simply call the common ftrace_return_to_handler function and
-that will return the original return address with which, you can return to the
+that will return the original return address with which you can return to the
 original call site.
 
 Here is the updated mcount pseudo code:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
lib-stringc-fix-kernel-doc-warnings.patch
mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch
docs-large-update-to-ioctl-numbertxt.patch
documentation-update-mmiotracetxt.patch
documentation-update-tracepoint-analysistxt.patch
documentation-update-ftrace-designtxt.patch
documentation-update-ring-buffer-designtxt.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

