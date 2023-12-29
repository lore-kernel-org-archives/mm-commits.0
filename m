Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47F314009
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NcBZQ5lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851E8C433C9;
	Fri, 29 Dec 2023 20:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881391;
	bh=Zq1pBunCgIJSgv5ohfyTiM07ESaGC03KYtHI818z+Mk=;
	h=Date:To:From:Subject:From;
	b=NcBZQ5lbKdYBYRWWixgND88RVKUE0o/hmNDFMv8xvTnCBCCogLJRbXiTZgUgZibJL
	 KZw2SHoNVPQYrRaVHE1JyPxmgPR6PeFltZyJ+3dgh1x8uIhqlm2b0HR29ADpPr0jtt
	 v1ofaYmrZjTf983l1ugEbrGRcjguBbK6g2lWAMdY=
Date: Fri, 29 Dec 2023 12:23:11 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch removed from -mm tree
Message-Id: <20231229202311.851E8C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file: fix incorrect temp_start value in locate_mem_hole_top_down()
has been removed from the -mm tree.  Its filename was
     kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: kexec_file: fix incorrect temp_start value in locate_mem_hole_top_down()
Date: Sun, 17 Dec 2023 11:35:27 +0800

temp_end represents the address of the last available byte.  Therefore,
the starting address of the memory segment with temp_end as its last
available byte and a size of `kbuf->memsz`, that is, the value of
temp_start, should be `temp_end - kbuf->memsz + 1` instead of `temp_end -
kbuf->memsz`.

Additionally, use the ALIGN_DOWN macro instead of open-coding it directly
in locate_mem_hole_top_down() to improve code readability.

Link: https://lkml.kernel.org/r/20231217033528.303333-3-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_file.c~kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down
+++ a/kernel/kexec_file.c
@@ -434,11 +434,11 @@ static int locate_mem_hole_top_down(unsi
 	unsigned long temp_start, temp_end;
 
 	temp_end = min(end, kbuf->buf_max);
-	temp_start = temp_end - kbuf->memsz;
+	temp_start = temp_end - kbuf->memsz + 1;
 
 	do {
 		/* align down start */
-		temp_start = temp_start & (~(kbuf->buf_align - 1));
+		temp_start = ALIGN_DOWN(temp_start, kbuf->buf_align);
 
 		if (temp_start < start || temp_start < kbuf->buf_min)
 			return 0;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch

