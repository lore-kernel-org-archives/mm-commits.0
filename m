From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 144/166] kallsyms: unexport kallsyms_lookup_name()
 and kallsyms_on_each_symbol()
Date: Mon, 06 Apr 2020 20:11:43 -0700
Message-ID: <20200407031143.TIUdoIaga%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgDGDLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:45 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, joe.lawrence@redhat.com, linux-mm@kvack.org, mathieu.desnoyers@efficios.com, mbenes@suse.cz, mhiramat@kernel.org, mm-commits@vger.kernel.org, pmladek@suse.com, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

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
Reviewed-by: Quentin Perret <qperret@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
