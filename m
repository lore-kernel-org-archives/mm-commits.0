From: akpm@linux-foundation.org
Subject: [merged] docs-correct-documentation-for-%pk.patch removed
 from -mm tree
Date: Thu, 30 Nov 2017 12:19:32 -0800
Message-ID: <20171130201932.sbKDW-y2_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdK3UTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, will.deacon@arm.com, william.c.roberts@intel.com


The patch titled
     Subject: docs: correct documentation for %pK
has been removed from the -mm tree.  Its filename was
     docs-correct-documentation-for-%pk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: docs: correct documentation for %pK

Patch series "hash addresses printed with %p", v11.

Currently there exist approximately 14000 places in the Kernel where
addresses are being printed using an unadorned %p.  This potentially leaks
sensitive information regarding the Kernel layout in memory.  Many of
these calls are stale, instead of fixing every call lets hash the address
by default before printing.  This will of course break some users, forcing
code printing needed addresses to be updated.  We can add a printk
specifier for this purpose (%px) to give developers a clear upgrade path
for breakages caused by applying this patch set.

The added advantage of hashing %p is that security is now opt-out, if you
_really_ want the address you have to work a little harder and use %px.

The idea for creating the printk specifier %px to print the actual address
was suggested by Kees Cook (see below for email threads by subject).

Newbie question: I don't know who is potentially going to want to apply
this, I've CC'd Andrew Morton.  I'm guessing this should go into
linux-next so we can see what breaks?  I do not know exactly how code gets
into linux-next.  I've CC'd Stephen Rothwell.

Here is the behaviour that this series implements.

For kpt_restrict==0

Randomness not ready:
  printed with %p:                     (ptrval)     # NOTE: with padding
Valid pointer:
  printed with %pK:             deadbeefdeadbeef
  printed with %p:              00000000deadbeef
  malformed specifier (eg %i):  00000000deadbeef
NULL pointer:
  printed with %pK:             0000000000000000
  printed with %p:                       (null)     # NOTE: with padding
  malformed specifier (eg %i):           (null)

For kpt_restrict==2

Valid pointer:
  printed with %pK:             0000000000000000

All other output as for kptr_restrict==0


Why hash the addresses rather than simply printing "<obscured>" in their
place?  

Consensus is that if we provide a unique identifier (the hashed address)
then this is useful for debugging (i.e differentiating between structs
when you have a list of them).

The first 32 bits (on 64 bit machines) were zeroed out because

1. they are unnecessary in achieving the aim.
2. it reduces noise.
3. makes explicit some funny business was going on.

And bonus points, hopefully we don't break userland tools that parse
addresses if the format is still the same.


This patch (of 5):

Current documentation indicates that %pK prints a leading '0x'.  This is
not the case.

Correct documentation for printk specifier %pK.

Link: http://lkml.kernel.org/r/1511921105-3647-2-git-send-email-me@tobin.cc
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Fries <cfries@google.com>
Cc: Dave Weinstein <olorin@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: Radim Kr\u010dm\u0159 <rkrcmar@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN Documentation/printk-formats.txt~docs-correct-documentation-for-%pk Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~docs-correct-documentation-for-%pk
+++ a/Documentation/printk-formats.txt
@@ -85,13 +85,12 @@ Examples::
 	printk("Faulted at %pS\n", (void *)regs->ip);
 	printk(" %s%pB\n", (reliable ? "" : "? "), (void *)*stack);
 
