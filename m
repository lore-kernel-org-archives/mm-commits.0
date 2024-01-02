Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7839156C9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YdracvL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33254C433BB;
	Tue,  2 Jan 2024 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704218138;
	bh=vzZderrdlDB9srC0FizC0F4MiNEmELiCqJpD6o/cMJI=;
	h=Date:To:From:Subject:From;
	b=YdracvL3fXyO6hxHX/uuC+wqcaCcjn7RmL24higYe4jYCRYMs7yu8E9YrIy1eM6lW
	 i2ZQy0ooct99iD1KPH76g7HDKOqfYMx8wOHWvvxKJmCGFwAkWimocoRZc6WA2NU2/c
	 0U24EsA1P+TUHs6V2bA4ax0PnFVm8QnqCjJwvKHs=
Date: Tue, 02 Jan 2024 09:55:37 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,seanjc@google.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] crash_core-optimize-crash_exclude_mem_range.patch removed from -mm tree
Message-Id: <20240102175538.33254C433BB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_core: optimize crash_exclude_mem_range()
has been removed from the -mm tree.  Its filename was
     crash_core-optimize-crash_exclude_mem_range.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: crash_core: optimize crash_exclude_mem_range()
Date: Wed, 20 Dec 2023 00:34:18 +0800

Because memory ranges in mem->ranges are stored in ascending order, when
we detect `p_end < start`, we can break the for loop early, as the
subsequent memory ranges must also be outside the range we are looking
for.

Link: https://lkml.kernel.org/r/20231219163418.108591-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/crash_core.c~crash_core-optimize-crash_exclude_mem_range
+++ a/kernel/crash_core.c
@@ -575,9 +575,12 @@ int crash_exclude_mem_range(struct crash
 		p_start = mstart;
 		p_end = mend;
 
-		if (p_start > end || p_end < start)
+		if (p_start > end)
 			continue;
 
+		if (p_end < start)
+			break;
+
 		/* Truncate any area outside of range */
 		if (p_start < start)
 			p_start = start;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch

