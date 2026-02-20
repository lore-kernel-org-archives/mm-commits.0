Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E57F2DCC03
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771621627; cv=none; b=gQVYE0/I/etoWgNGVGt0XA4sL4PwG4+6x/I40AVBUYZo21JnO0Sy+T54R6JuXb7bDjtw3oMLwlRW3uZ54KsZnusDN6RgD44qVWfDPVPcangPgf7O69/hWDp0itWDQ/GkJSlvP+Nh6TKClufm3WiECgchxRL7FjMtkK+gmytp6UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771621627; c=relaxed/simple;
	bh=UKThgzll29dxPC9cXRN4rqlknyN8D8xbHIt48tz8tlw=;
	h=Date:To:From:Subject:Message-Id; b=WIOobig09OGMZmi/DFwWaxDB51YvMkY6X+lD9PrsRE+LK+q2oSa6/uIN4lhh0GFuK9cVV/0dyEIBiCoImBBNS1UnRgAAU0DstP1IUFYEqsS4MHN2+Q2TnDLy5QYOQUI5n3lBz4/gn1FjD875jEKAE1A5UBgICeX+LAV/32I+d4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jW2oPe+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jW2oPe+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24716C116C6;
	Fri, 20 Feb 2026 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771621627;
	bh=UKThgzll29dxPC9cXRN4rqlknyN8D8xbHIt48tz8tlw=;
	h=Date:To:From:Subject:From;
	b=jW2oPe+cPrv8eVMtNxTXMmaxCbdn5EiowlVSVUFDtRNOrNm/7T51LMzuOvS/EnGzE
	 sO/mmrNucH+IjC+SJsni1EWpZ9JxtchYRRbnQXXEoYf4lMagnRS9/WenlMRY0agfCt
	 daKutpCpc186b8Y9xbfHxjIzE95kZCEgjZjAooTc=
Date: Fri, 20 Feb 2026 13:07:06 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,rioo.tsukatsukii@gmail.com,pmladek@suse.com,joel.granados@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260220210707.24716C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
Date: Fri Feb 20 01:05:15 PM PST 2026

fix spello, add comment

Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rio <rioo.tsukatsukii@gmail.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
+++ a/kernel/panic.c
@@ -801,6 +801,8 @@ EXPORT_SYMBOL(panic);
  * Documentation/admin-guide/tainted-kernels.rst, including its
  * small shell script that prints the TAINT_FLAGS_COUNT bits of
  * /proc/sys/kernel/tainted.
+ *
+ * Also, update TAINT_BUF_MAX below.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G'),
@@ -854,7 +856,7 @@ static void print_tainted_seq(struct seq
 	}
 }
 
-/* 350 can accomadate all taint flags in verbose mode, with some headroom */
+/* 350 can accommodate all taint flags in verbose mode, with some headroom */
 #define TAINT_BUF_MAX 350
 
 static const char *_print_tainted(bool verbose)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
lib-introduce-hierarchical-per-cpu-counters-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

