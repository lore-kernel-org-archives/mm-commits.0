Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FFD289824
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766961429; cv=none; b=gRwYVerPOs/rQj6lNPMRdknaxhh/ZFBNe5XyQpdLBSQaKd83+570e+6VTt5cflduXnPNTahTV9OxpUMPwAzI3xGDiuc/oP4H3LSGuShrFNbPIy4+2cJnTYUsfchWIJsr7S/p20rWRR9P8lXQO6YWDnM+Ew3PW/tHtSDB73E6R+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766961429; c=relaxed/simple;
	bh=GyKxkfW9k+3VCtwdAUf5uh4eBZ60JDLj7eBTmppt484=;
	h=Date:To:From:Subject:Message-Id; b=iD/tdIHk+MKRnq6hcghuqwt6o92gFRMLMJrhNyy/75YlzVw6GZru/pZPfxryeDIcgBk+pZZwnltrgDzXwLg5F6hznzwQOOTeOkXkS3LTvmk9i/EfqzJl9kgEG7q3zFcXerUZIXHukpSHy6QCB9LmHRr90RW9z6gOFGU0c7MdvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLOP3xSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLOP3xSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A638C4CEFB;
	Sun, 28 Dec 2025 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766961429;
	bh=GyKxkfW9k+3VCtwdAUf5uh4eBZ60JDLj7eBTmppt484=;
	h=Date:To:From:Subject:From;
	b=MLOP3xSfWrr0Ec8tTat8qif+Xl/VMJt46fHDZfRNTAVzi+g6lAVuMhI2zsLC6FubB
	 7FzX9HYuiPrWvQr3wL4TvaBbcORCImx4qTdkGFK1AkTOD4CWAtK2RMBkC+S51H5avn
	 9Meeikdrc6UpC16IVaNTI6aruqAwIDfvcTiYOKtI=
Date: Sun, 28 Dec 2025 14:37:08 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,bp@alien8.de,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-ignore-hugepage-kernel-args-if-hugepages-are-unsupported.patch added to mm-hotfixes-unstable branch
Message-Id: <20251228223709.4A638C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-ignore-hugepage-kernel-args-if-hugepages-are-unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-ignore-hugepage-kernel-args-if-hugepages-are-unsupported.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
Date: Wed, 24 Dec 2025 17:25:24 +0530

Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
default_hugepagesz) when hugepages are not supported by the architecture.

Some architectures may need to disable hugepages based on conditions
discovered during kernel boot.  The hugepages_supported() helper allows
architecture code to advertise whether hugepages are supported.

Currently, normal hugepage allocation is guarded by hugepages_supported(),
but gigantic hugepages are allocated regardless of this check.  This
causes problems on powerpc for fadump (firmware- assisted dump).

In the fadump (firmware-assisted dump) scenario, a production kernel crash
causes the system to boot into a special kernel whose sole purpose is to
collect the memory dump and reboot.  Features such as hugepages are not
required in this environment and should be disabled.

For example, when the fadump kernel boots with the following kernel
arguments:
default_hugepagesz=1GB hugepagesz=1GB hugepages=200

Before this patch, the kernel prints the following logs:

 HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
 HugeTLB support is disabled!
 HugeTLB: huge pages not supported, ignoring associated command-line parameters
 hugetlbfs: disabling because there are no supported hugepage sizes

Even though the logs state that HugeTLB support is disabled, gigantic
hugepages are still allocated. This causes the fadump kernel to run out
of memory during boot.

After this patch is applied, the kernel prints the following logs for
the same command line:

 HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
 HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
 HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
 HugeTLB support is disabled!
 hugetlbfs: disabling because there are no supported hugepage sizes

To fix the issue, gigantic hugepage allocation should be guarded by
hugepages_supported().

Previously, two approaches were proposed to bring gigantic hugepage
allocation under hugepages_supported():

[1] Check hugepages_supported() in the generic code before allocating
    gigantic hugepages

[2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes

Approach [2] has two minor issues:
1. It prints misleading logs about invalid hugepage sizes
2. The kernel still processes hugepage kernel arguments unnecessarily

To control gigantic hugepage allocation, skip processing hugepage kernel
arguments (default_hugepagesz, hugepagesz and hugepages) when
hugepages_supported() returns false.

Note for backporting: This fix is a partial reversion of the commit
mentioned in the Fixes tag and is only valid once the change referenced by
the Depends-on tag is present.  When backporting this patch, the commit
mentioned in the Depends-on tag must be included first.

Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
Link: https://lkml.kernel.org/r/20251224115524.1272010-1-sourabhjain@linux.ibm.com
Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Depends-on: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-ignore-hugepage-kernel-args-if-hugepages-are-unsupported
+++ a/mm/hugetlb.c
@@ -4286,6 +4286,11 @@ static int __init hugepages_setup(char *
 	unsigned long tmp;
 	char *p = s;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
+		return 0;
+	}
+
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
@@ -4366,6 +4371,11 @@ static int __init hugepagesz_setup(char
 	unsigned long size;
 	struct hstate *h;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
+		return 0;
+	}
+
 	parsed_valid_hugepagesz = false;
 	size = (unsigned long)memparse(s, NULL);
 
@@ -4414,6 +4424,12 @@ static int __init default_hugepagesz_set
 	unsigned long size;
 	int i;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
+			s);
+		return 0;
+	}
+
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
 		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

mm-hugetlb-ignore-hugepage-kernel-args-if-hugepages-are-unsupported.patch

