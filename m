From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch
 added to -mm tree
Date: Mon, 24 Feb 2020 14:30:58 -0800
Message-ID: <20200224223058.MDhlAs7u0%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWbB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:31:01 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: samples/hw_breakpoint: drop HW_BREAKPOINT_R when reporting writes
has been added to the -mm tree.  Its filename is
     samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
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

Patches currently in -mm which might be from will@kernel.org are

samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch
samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch
kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch
