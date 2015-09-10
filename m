From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-processing-nofunc-for-functions-only.patch
 added to -mm tree
Date: Thu, 10 Sep 2015 15:20:13 -0700
Message-ID: <55f2021d.2GQJoarR9pPqVMcX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbIJWUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 18:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danilo.cesar@collabora.co.uk, corbet@lwn.net, daniel.vetter@ffwll.ch, johannes.berg@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kernel-doc: processing -nofunc for functions only
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-processing-nofunc-for-functions-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-kernel-doc-processing-nofunc-for-functions-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-kernel-doc-processing-nofunc-for-functions-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>
Subject: scripts/kernel-doc: processing -nofunc for functions only

Docproc process EXPORT_SYMBOL(f1) macro and uses -nofunc f1 to avoid
duplicated documentation in the next call.  It works for most of the
cases, but there are some specific situations where a struct has the same
name of an already-exported function.

Current kernel-doc behavior ignores those structs and do not add them to
the final documentation.  This patch fixes it.

This is non-usual and the only case I've found is the drm_modeset_lock
(function and struct) defined in drm_modeset_lock.h and
drm_modeset_lock.c.  Considering this, it should only affect the DRM
documentation by including struct drm_modeset_lock to the final Docbook.

Signed-off-by: Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-processing-nofunc-for-functions-only scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-processing-nofunc-for-functions-only
+++ a/scripts/kernel-doc
@@ -1746,7 +1746,7 @@ sub output_declaration {
     my $func = "output_${functype}_$output_mode";
     if (($function_only==0) ||
 	( $function_only == 1 && defined($function_table{$name})) ||
-	( $function_only == 2 && !defined($function_table{$name})))
+	( $function_only == 2 && !($functype eq "function" && defined($function_table{$name}))))
     {
 	&$func(@_);
 	$section_counter++;
_

Patches currently in -mm which might be from danilo.cesar@collabora.co.uk are

scripts-kernel-doc-processing-nofunc-for-functions-only.patch

