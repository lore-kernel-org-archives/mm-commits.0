From: akpm@linux-foundation.org
Subject: + checkpatch-add-additional-attribute-defines.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:31 -0700
Message-ID: <201008182025.o7IKPWcl010356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab0HRUb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, davej@codemonkey.org.uk


The patch titled
     checkpatch: Add additional attribute #defines
has been added to the -mm tree.  Its filename is
     checkpatch-add-additional-attribute-defines.patch

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
Subject: checkpatch: Add additional attribute #defines
From: Joe Perches <joe@perches.com>

On Wed, 2010-08-11 at 12:35 -0400, Dave Jones wrote:
> I just got this from a patch I merged..
>
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #121: FILE: arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c:113:
> +static struct pcc_cpu __percpu *pcc_cpu_info;
>                                 ^
> which doesn't seem right.

Perhaps these need to be added to checkpatch.

[apw@canonical.com: added tests]
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-additional-attribute-defines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-additional-attribute-defines
+++ a/scripts/checkpatch.pl
@@ -152,6 +152,20 @@ our $Sparse	= qr{
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
+			__percpu|
+			__nocast|
+			__safe|
+			__bitwise__|
+			__packed__|
+			__packed2__|
+			__naked|
+			__maybe_unused|
+			__always_unused|
+			__noreturn|
+			__used|
+			__cold|
+			__noclone|
+			__deprecated|
 			__read_mostly|
 			__kprobes|
 			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
checkpatchpl-add-check-for-space-after-struct-or-union-definition.patch

