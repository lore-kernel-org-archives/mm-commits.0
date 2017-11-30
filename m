From: akpm@linux-foundation.org
Subject: [merged] vsprintf-add-printk-specifier-%px.patch removed
 from -mm tree
Date: Thu, 30 Nov 2017 12:19:44 -0800
Message-ID: <20171130201944.bxz6qwWTl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdK3UTq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, will.deacon@arm.com, william.c.roberts@intel.com


The patch titled
     Subject: vsprintf: add printk specifier %px
has been removed from the -mm tree.  Its filename was
     vsprintf-add-printk-specifier-%px.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: vsprintf: add printk specifier %px

printk specifier %p now hashes all addresses before printing.  Sometimes
we need to see the actual unmodified address.  This can be achieved using
%lx but then we face the risk that if in future we want to change the way
the Kernel handles printing of pointers we will have to grep through the
already existent 50 000 %lx call sites.  Let's add specifier %px as a
clear, opt-in, way to print a pointer and maintain some level of isolation
from all the other hex integer output within the Kernel.

Add printk specifier %px to print the actual unmodified address.

Link: http://lkml.kernel.org/r/1511921105-3647-5-git-send-email-me@tobin.cc
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
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   18 +++++++++++++++++-
 lib/vsprintf.c                   |   18 ++++++++++++++++++
 scripts/checkpatch.pl            |    2 +-
 3 files changed, 36 insertions(+), 2 deletions(-)

diff -puN Documentation/printk-formats.txt~vsprintf-add-printk-specifier-%px Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~vsprintf-add-printk-specifier-%px
+++ a/Documentation/printk-formats.txt
@@ -49,7 +49,8 @@ Pointer Types
 
 Pointers printed without a specifier extension (i.e unadorned %p) are
 hashed to give a unique identifier without leaking kernel addresses to user
-space. On 64 bit machines the first 32 bits are zeroed.
+space. On 64 bit machines the first 32 bits are zeroed. If you _really_
+want the address see %px below.
 
 ::
 
@@ -106,6 +107,21 @@ For printing kernel pointers which shoul
 users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
 Documentation/sysctl/kernel.txt for more details.
 
+Unmodified Addresses
+====================
+
+::
+
+	%px	01234567 or 0123456789abcdef
+
+For printing pointers when you _really_ want to print the address. Please
+consider whether or not you are leaking sensitive information about the
+Kernel layout in memory before printing pointers with %px. %px is
+functionally equivalent to %lx. %px is preferred to %lx because it is more
+uniquely grep'able. If, in the future, we need to modify the way the Kernel
+handles printing pointers it will be nice to be able to find the call
+sites.
+
 Struct Resources
 ================
 
diff -puN lib/vsprintf.c~vsprintf-add-printk-specifier-%px lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-add-printk-specifier-%px
+++ a/lib/vsprintf.c
@@ -1646,6 +1646,20 @@ char *device_node_string(char *buf, char
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static noinline_for_stack
+char *pointer_string(char *buf, char *end, const void *ptr,
+		     struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(ptr);
+		spec.flags |= ZEROPAD;
+	}
+
+	return number(buf, end, (unsigned long int)ptr, spec);
+}
+
 static bool have_filled_random_ptr_key __read_mostly;
 static siphash_key_t ptr_key __read_mostly;
 
@@ -1818,6 +1832,8 @@ static char *ptr_to_id(char *buf, char *
  *                        c major compatible string
  *                        C full compatible string
  *
+ * - 'x' For printing the address. Equivalent to "%lx".
+ *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
@@ -1940,6 +1956,8 @@ char *pointer(const char *fmt, char *buf
 		case 'F':
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
+	case 'x':
+		return pointer_string(buf, end, ptr, spec);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
diff -puN scripts/checkpatch.pl~vsprintf-add-printk-specifier-%px scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~vsprintf-add-printk-specifier-%px
+++ a/scripts/checkpatch.pl
@@ -5753,7 +5753,7 @@ sub process {
 		        for (my $count = $linenr; $count <= $lc; $count++) {
 				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
 				$fmt =~ s/%%//g;
-				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNO]).)/) {
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNOx]).)/) {
 					$bad_extension = $1;
 					last;
 				}
_

Patches currently in -mm which might be from me@tobin.cc are


