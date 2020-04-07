From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 142/166] samples/hw_breakpoint: drop
 HW_BREAKPOINT_R when reporting writes
Date: Mon, 06 Apr 2020 20:11:36 -0700
Message-ID: <20200407031136.19sEo9A3l%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgDGDLi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:38 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, joe.lawrence@redhat.com, linux-mm@kvack.org, mbenes@suse.cz, mhiramat@kernel.org, mm-commits@vger.kernel.org, pmladek@suse.com, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

From: Will Deacon <will@kernel.org>
Subject: samples/hw_breakpoint: drop HW_BREAKPOINT_R when reporting writes

Patch series "Unexport kallsyms_lookup_name() and kallsyms_on_each_symbol()".

Despite having just a single modular in-tree user that I could spot,
kallsyms_lookup_name() is exported to modules and provides a mechanism
for out-of-tree modules to access and invoke arbitrary, non-exported
kernel symbols when kallsyms is enabled.

This patch series fixes up that one user and unexports the symbol along
with kallsyms_on_each_symbol(), since that could also be abused in a
similar manner.

I would like to avoid out-of-tree modules being easily able to call
functions that are not exported.  kallsyms_lookup_name() makes this
trivial to the point that there is very little incentive to rework these
modules to either use upstream interfaces correctly or propose
functionality which may be otherwise missing upstream.  Both of these
latter solutions would be pre-requisites to upstreaming these modules, and
the current state of things actively discourages that approach.

The background here is that we are aiming for Android devices to be able
to use a generic binary kernel image closely following upstream, with any
vendor extensions coming in as kernel modules.  In this case, we (Google)
end up maintaining the binary module ABI within the scope of a single LTS
kernel.  Monitoring and managing the ABI surface is not feasible if it
effectively includes all data and functions via kallsyms_lookup_name(). 
Of course, we could just carry this patch in the Android kernel tree, but
we're aiming to carry as little as possible (ideally nothing) and I think
it's a sensible change in its own right.  I'm surprised you object to it,
in all honesty.

Now, you could turn around and say "that's not upstream's problem", but it
still seems highly undesirable to me to have an upstream bypass for
exported symbols that isn't even used by upstream modules.  It's ripe for
abuse and encourages people to work outside of the upstream tree.  The
usual rule is that we don't export symbols without a user in the tree and
that seems especially relevant in this case.

Joe Lawrence said:

: FWIW, kallsyms was historically used by the out-of-tree kpatch support
: module to resolve external symbols as well as call set_memory_r{w,o}()
: API.  All of that support code has been merged upstream, so modern kpatch
: modules* no longer leverage kallsyms by default.
: 
: That said, there are still some users who still use the deprecated support
: module with newer kernels, but that is not officially supported by the
: project.


This patch (of 3):

Given the name of a kernel symbol, the 'data_breakpoint' test claims to
"report any write operations on the kernel symbol".  However, it creates
the breakpoint using both HW_BREAKPOINT_W and HW_BREAKPOINT_R, which menas
it also fires for read access.

Drop HW_BREAKPOINT_R from the breakpoint attributes.

Link: http://lkml.kernel.org/r/20200221114404.14641-2-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/hw_breakpoint/data_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/hw_breakpoint/data_breakpoint.c~samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes
+++ a/samples/hw_breakpoint/data_breakpoint.c
@@ -45,7 +45,7 @@ static int __init hw_break_module_init(v
 	hw_breakpoint_init(&attr);
 	attr.bp_addr = kallsyms_lookup_name(ksym_name);
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
-	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
+	attr.bp_type = HW_BREAKPOINT_W;
 
 	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
 	if (IS_ERR((void __force *)sample_hbp)) {
_
