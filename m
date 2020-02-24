From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch
 added to -mm tree
Date: Mon, 24 Feb 2020 14:31:04 -0800
Message-ID: <20200224223104.OkR0H64Vm%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWbI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:31:08 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: kallsyms: unexport kallsyms_lookup_name() and kallsyms_on_each_symbol()
has been added to the -mm tree.  Its filename is
     kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch

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
Subject: kallsyms: unexport kallsyms_lookup_name() and kallsyms_on_each_symbol()

kallsyms_lookup_name() and kallsyms_on_each_symbol() are exported to
modules despite having no in-tree users and being wide open to abuse by
out-of-tree modules that can use them as a method to invoke arbitrary
non-exported kernel functions.

Unexport kallsyms_lookup_name() and kallsyms_on_each_symbol().

Link: http://lkml.kernel.org/r/20200221114404.14641-4-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Quentin Perret <qperret@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol
+++ a/kernel/kallsyms.c
@@ -175,7 +175,6 @@ unsigned long kallsyms_lookup_name(const
 	}
 	return module_kallsyms_lookup_name(name);
 }
-EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
 
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
@@ -194,7 +193,6 @@ int kallsyms_on_each_symbol(int (*fn)(vo
 	}
 	return module_kallsyms_on_each_symbol(fn, data);
 }
-EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
_

Patches currently in -mm which might be from will@kernel.org are

samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch
samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch
kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch
