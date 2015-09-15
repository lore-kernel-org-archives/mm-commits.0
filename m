From: akpm@linux-foundation.org
Subject: [merged]
 scripts-kernel-doc-processing-nofunc-for-functions-only.patch removed from
 -mm tree
Date: Tue, 15 Sep 2015 12:23:43 -0700
Message-ID: <55f8703f.BVQ0xnk/HDnYKYxr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbIOTXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 15:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danilo.cesar@collabora.co.uk, corbet@lwn.net, daniel.vetter@ffwll.ch, johannes.berg@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kernel-doc: processing -nofunc for functions only
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-processing-nofunc-for-functions-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


