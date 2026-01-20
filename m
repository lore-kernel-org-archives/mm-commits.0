Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D33A7DEB
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939796; cv=none; b=KUPqUReGIy+vCPvJPgg/WinKwRppK3IHDm7JN2HrqTFVR7s5DZcBzzYwNlUPxZumQO9mSrIinZCu+JClYR+KfNGCVer4iMkXhoybJ0MI7d1ZqxJQPPBbAdvbi1zpTxXQb0/5E1hk7/h71R/vby2ANDM8tgZDOA+SE/bNflkZjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939796; c=relaxed/simple;
	bh=dbHFpwYDSCe8nGZR9H0CRnq34ftzOggomZktZFoF2oI=;
	h=Date:To:From:Subject:Message-Id; b=V/3t3qnZx18m7FNbaJ7VR2R/D1AdvRtZV72qfGwgeRnXqxVJ0bcpDe5t3RHKVGWvBpD4s/0GxMA/NtU13lEVGk/ReoUPDIh0SYtoKsP2gUoX4dGB69kI+jKaZmBPr8qjnNqsgJ8JXcSSbBhDNWmqXQaTTBrsC8gtmBntdkZ5JeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EY22V/FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EY22V/FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BC1C16AAE;
	Tue, 20 Jan 2026 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768939796;
	bh=dbHFpwYDSCe8nGZR9H0CRnq34ftzOggomZktZFoF2oI=;
	h=Date:To:From:Subject:From;
	b=EY22V/FBGmX94IC0fnUTvcupCk5+iAYlPFSqgkBQDD5XBHnFQITHawy+ZlpKk+2jL
	 r/HRMqh4xedwADcnH8U//TxsamtCuN88pCU6lOsRfXz5jPWUNuZcSCTytp0YhTVhcS
	 AIRSFTkTIF/PQDlRGE2c+7rArzlYt3WZLPmXmiOA=
Date: Tue, 20 Jan 2026 12:09:55 -0800
To: mm-commits@vger.kernel.org,zwisler@google.com,sourabhjain@linux.ibm.com,rostedt@goodmis.org,ribalda@chromium.org,prudo@redhat.com,graf@amazon.com,ebiggers@kernel.org,bhe@redhat.com,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-derive-purgatory-entry-from-symbol.patch added to mm-nonmm-unstable branch
Message-Id: <20260120200956.00BC1C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: derive purgatory entry from symbol
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-derive-purgatory-entry-from-symbol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-derive-purgatory-entry-from-symbol.patch

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
From: Li Chen <me@linux.beauty>
Subject: kexec: derive purgatory entry from symbol
Date: Tue, 20 Jan 2026 20:40:04 +0800

kexec_load_purgatory() derives image->start by locating e_entry inside an
SHF_EXECINSTR section.  If the purgatory object contains multiple
executable sections with overlapping sh_addr, the entrypoint check can
match more than once and trigger a WARN.

Derive the entry section from the purgatory_start symbol when present and
compute image->start from its final placement.  Keep the existing e_entry
fallback for purgatories that do not expose the symbol.

WARNING: kernel/kexec_file.c:1009 at kexec_load_purgatory+0x395/0x3c0, CPU#10: kexec/1784
Call Trace:
 <TASK>
 bzImage64_load+0x133/0xa00
 __do_sys_kexec_file_load+0x2b3/0x5c0
 do_syscall_64+0x81/0x610
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20260120124005.148381-1-me@linux.beauty
Fixes: 8652d44f466a ("kexec: support purgatories with .text.hot sections")
Signed-off-by: Li Chen <me@linux.beauty>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Li Chen <me@linux.beauty>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ricardo Ribalda Delgado <ribalda@chromium.org>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/kernel/kexec_file.c~kexec-derive-purgatory-entry-from-symbol
+++ a/kernel/kexec_file.c
@@ -880,6 +880,8 @@ out_free_sha_regions:
 }
 
 #ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
+static const Elf_Sym * kexec_purgatory_find_symbol(struct purgatory_info *pi,
+			      const char *name);
 /*
  * kexec_purgatory_setup_kbuf - prepare buffer to load purgatory.
  * @pi:		Purgatory to be loaded.
@@ -958,6 +960,10 @@ static int kexec_purgatory_setup_sechdrs
 	unsigned long offset;
 	size_t sechdrs_size;
 	Elf_Shdr *sechdrs;
+	const Elf_Sym *entry_sym;
+	u16 entry_shndx = 0;
+	unsigned long entry_off = 0;
+	bool start_fixed = false;
 	int i;
 
 	/*
@@ -975,6 +981,12 @@ static int kexec_purgatory_setup_sechdrs
 	bss_addr = kbuf->mem + kbuf->bufsz;
 	kbuf->image->start = pi->ehdr->e_entry;
 
+	entry_sym = kexec_purgatory_find_symbol(pi, "purgatory_start");
+	if (entry_sym) {
+		entry_shndx = entry_sym->st_shndx;
+		entry_off = entry_sym->st_value;
+	}
+
 	for (i = 0; i < pi->ehdr->e_shnum; i++) {
 		unsigned long align;
 		void *src, *dst;
@@ -992,6 +1004,13 @@ static int kexec_purgatory_setup_sechdrs
 
 		offset = ALIGN(offset, align);
 
+		if (!start_fixed && entry_sym && i == entry_shndx &&
+		    (sechdrs[i].sh_flags & SHF_EXECINSTR) &&
+		    entry_off < sechdrs[i].sh_size) {
+			kbuf->image->start = kbuf->mem + offset + entry_off;
+			start_fixed = true;
+		}
+
 		/*
 		 * Check if the segment contains the entry point, if so,
 		 * calculate the value of image->start based on it.
@@ -1002,13 +1021,14 @@ static int kexec_purgatory_setup_sechdrs
 		 * is not set to the initial value, and warn the user so they
 		 * have a chance to fix their purgatory's linker script.
 		 */
-		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
+		if (!start_fixed && sechdrs[i].sh_flags & SHF_EXECINSTR &&
 		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
 		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
 					 + sechdrs[i].sh_size) &&
-		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {
+		    kbuf->image->start == pi->ehdr->e_entry) {
 			kbuf->image->start -= sechdrs[i].sh_addr;
 			kbuf->image->start += kbuf->mem + offset;
+			start_fixed = true;
 		}
 
 		src = (void *)pi->ehdr + sechdrs[i].sh_offset;
_

Patches currently in -mm which might be from me@linux.beauty are

kexec-derive-purgatory-entry-from-symbol.patch

