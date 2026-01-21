Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56662877ED
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967423; cv=none; b=OYhBNvskGcHg+zgWRWGun1LZTHANRErG420ttYxUmrXZOScsHQMC5+aU+ZxrL5887bYrn2fQ2qE1CQ5gjeklZAeXUvaDDzx3f7X/9fy1e3aJDXIA2fUVyOrs/sRPPXaLDCjLCP9tT170KLXkSpBMoiGwHjv7DjN4zEVBTixqCcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967423; c=relaxed/simple;
	bh=P2pQKaX+N7AJmu3aL8DFH0xcu0RQB1N7Lc/7OFTsCYk=;
	h=Date:To:From:Subject:Message-Id; b=o0m6waO9W6NlVUmExq9wsyWTo1yEv6jpdUlxX2ZZ45vTQSja9RAx8XxGHBogpAESBZyHg4kLfR56OWx2JTs40+LbaWq1o9iTdruW7OA5Y/UbG9bYnHLOD6ydTVpJYty9n++li76ooNBF2Ck6VAVPbAes1TVAcSKatrvIn+g/rcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vu1Qot8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vu1Qot8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAF5C116D0;
	Wed, 21 Jan 2026 03:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967423;
	bh=P2pQKaX+N7AJmu3aL8DFH0xcu0RQB1N7Lc/7OFTsCYk=;
	h=Date:To:From:Subject:From;
	b=vu1Qot8NDGKwS9Y7s1zPNxMAI31Nei5NWuAB+batRsE7wSecr1hMXKhBR2ePjrpQ1
	 sMxa+S5Ej5Naqf01oqNhu2iV/ZzAHapitngWZUDsLDWBa+MXzOxtPdHbC+Jw8zEd6k
	 eyiu6RwNDXBY8DipYz0uFYSAU6bQI/h0ZIVACr+o=
Date: Tue, 20 Jan 2026 19:50:23 -0800
To: mm-commits@vger.kernel.org,linux@leemhuis.info,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-chktaint-add-reporting-for-tainted-modules.patch removed from -mm tree
Message-Id: <20260121035023.8BAF5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel-chktaint: add reporting for tainted modules
has been removed from the -mm tree.  Its filename was
     kernel-chktaint-add-reporting-for-tainted-modules.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel-chktaint: add reporting for tainted modules
Date: Wed, 14 Jan 2026 22:47:56 -0800

Check all loaded modules and report any that have their 'taint'
flags set.  The tainted module output format is:
 * <module_name> (<taint_flags>)

Example output:

Kernel is "tainted" for the following reasons:
 * externally-built ('out-of-tree') module was loaded  (#12)
 * unsigned module was loaded (#13)
Raw taint value as int/string: 12288/'G           OE      '

Tainted modules:
 * dump_test (OE)

Link: https://lkml.kernel.org/r/20260115064756.531592-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/debugging/kernel-chktaint |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/tools/debugging/kernel-chktaint~kernel-chktaint-add-reporting-for-tainted-modules
+++ a/tools/debugging/kernel-chktaint
@@ -211,9 +211,25 @@ else
 	addout "J"
 	echo " * fwctl's mutating debug interface was used (#19)"
 fi
+echo "Raw taint value as int/string: $taint/'$out'"
+
+# report on any tainted loadable modules
+[ "$1" = "" ] && [ -r /sys/module/ ] && \
+	cnt=`grep [A-Z] /sys/module/*/taint | wc -l` || cnt=0
 
+if [ $cnt -ne 0 ]; then
+	echo
+	echo "Tainted modules:"
+	for dir in `ls /sys/module` ; do
+		if [ -r /sys/module/$dir/taint ]; then
+			modtnt=`cat /sys/module/$dir/taint`
+			[ "$modtnt" = "" ] || echo " * $dir ($modtnt)"
+		fi
+	done
+fi
+
+echo
 echo "For a more detailed explanation of the various taint flags see"
 echo " Documentation/admin-guide/tainted-kernels.rst in the Linux kernel sources"
 echo " or https://kernel.org/doc/html/latest/admin-guide/tainted-kernels.html"
-echo "Raw taint value as int/string: $taint/'$out'"
 #EOF#
_

Patches currently in -mm which might be from rdunlap@infradead.org are


