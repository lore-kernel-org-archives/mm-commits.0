From: akpm@linux-foundation.org
Subject: + kasan-use-%px-to-print-addresses-instead-of-%p.patch added to
 -mm tree
Date: Wed, 29 Nov 2017 15:25:42 -0800
Message-ID: <5a1f41f6.D6fkLi+OcuOVKbTC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752450AbdK2XZp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 18:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, wilal.deacon@arm.com, william.c.roberts@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use %px to print addresses instead of %p
has been added to the -mm tree.  Its filename is
     kasan-use-%px-to-print-addresses-instead-of-%p.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-use-%25px-to-print-addresses-instead-of-%25p.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-%25px-to-print-addresses-instead-of-%25p.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: kasan: use %px to print addresses instead of %p

Pointers printed with %p are now hashed by default.  Kasan needs the
actual address.  We can use the new printk specifier %px for this purpose.

Use %px instead of %p to print addresses.

Link: http://lkml.kernel.org/r/1511921105-3647-6-git-send-email-me@tobin.cc
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Fries <cfries@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Dave Weinstein <olorin@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <wilal.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/kasan/report.c~kasan-use-%px-to-print-addresses-instead-of-%p mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-use-%px-to-print-addresses-instead-of-%p
+++ a/mm/kasan/report.c
@@ -134,7 +134,7 @@ static void print_error_description(stru
 
 	pr_err("BUG: KASAN: %s in %pS\n",
 		bug_type, (void *)info->ip);
-	pr_err("%s of size %zu at addr %p by task %s/%d\n",
+	pr_err("%s of size %zu at addr %px by task %s/%d\n",
 		info->is_write ? "Write" : "Read", info->access_size,
 		info->access_addr, current->comm, task_pid_nr(current));
 }
@@ -206,7 +206,7 @@ static void describe_object_addr(struct
 	const char *rel_type;
 	int rel_bytes;
 
-	pr_err("The buggy address belongs to the object at %p\n"
+	pr_err("The buggy address belongs to the object at %px\n"
 	       " which belongs to the cache %s of size %d\n",
 		object, cache->name, cache->object_size);
 
@@ -225,7 +225,7 @@ static void describe_object_addr(struct
 	}
 
 	pr_err("The buggy address is located %d bytes %s of\n"
-	       " %d-byte region [%p, %p)\n",
+	       " %d-byte region [%px, %px)\n",
 		rel_bytes, rel_type, cache->object_size, (void *)object_addr,
 		(void *)(object_addr + cache->object_size));
 }
@@ -302,7 +302,7 @@ static void print_shadow_for_address(con
 		char shadow_buf[SHADOW_BYTES_PER_ROW];
 
 		snprintf(buffer, sizeof(buffer),
-			(i == 0) ? ">%p: " : " %p: ", kaddr);
+			(i == 0) ? ">%px: " : " %px: ", kaddr);
 		/*
 		 * We should not pass a shadow pointer to generic
 		 * function, because generic functions may try to
_

Patches currently in -mm which might be from me@tobin.cc are

docs-correct-documentation-for-%pk.patch
vsprintf-refactor-%pk-code-out-of-pointer.patch
printk-hash-addresses-printed-with-%p.patch
vsprintf-add-printk-specifier-%px.patch
kasan-use-%px-to-print-addresses-instead-of-%p.patch

