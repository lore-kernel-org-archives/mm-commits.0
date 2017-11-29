From: akpm@linux-foundation.org
Subject: + docs-correct-documentation-for-%pk.patch added to -mm tree
Date: Wed, 29 Nov 2017 15:25:25 -0800
Message-ID: <5a1f41e5.F5DFrFrCYDRbtJ0J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753255AbdK2XZ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 18:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, wilal.deacon@arm.com, william.c.roberts@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs: correct documentation for %pK
has been added to the -mm tree.  Its filename is
     docs-correct-documentation-for-%pk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-correct-documentation-for-%25pk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-correct-documentation-for-%25pk.patch

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



This patch (of 5)"

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
Cc: Will Deacon <wilal.deacon@arm.com>
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
 
