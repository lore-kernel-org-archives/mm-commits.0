Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4BC358B8
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dn6+jovs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365EC433C7;
	Fri,  5 Jan 2024 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704480365;
	bh=4VtiJTpIK7Xru56lOyMK4IAr0+1S962iOWkxqbRo19I=;
	h=Date:To:From:Subject:From;
	b=Dn6+jovsgUpEjo8arxKJe8qhLmr44477zIXXvptfm6TPus/ImRPY/BJEZsoRlyivo
	 aJD1Xb2TwXR0TlIQ6HW9yu9T6paZb9nZkNERudOtHnd2qhX7iu3sLzp8A+aUfODzRB
	 bz8BHWnrEqw4NxJQo89K9QegScAhx6A3/BOXOVrA=
Date: Fri, 05 Jan 2024 10:46:05 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,sourabhjain@linux.ibm.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch removed from -mm tree
Message-Id: <20240105184605.A365EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: use SZ_1M macro instead of hardcoded value
has been removed from the -mm tree.  Its filename was
     x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/crash: use SZ_1M macro instead of hardcoded value
Date: Tue, 2 Jan 2024 22:49:04 +0800

Use SZ_1M macro instead of hardcoded 1<<20 to make code more readable.

Link: https://lkml.kernel.org/r/20240102144905.110047-3-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash.c~x86-crash-use-sz_1m-macro-instead-of-hardcoded-value
+++ a/arch/x86/kernel/crash.c
@@ -170,7 +170,7 @@ static int elf_header_exclude_ranges(str
 	int ret = 0;
 
 	/* Exclude the low 1M because it is always reserved */
-	ret = crash_exclude_mem_range(cmem, 0, (1<<20)-1);
+	ret = crash_exclude_mem_range(cmem, 0, SZ_1M - 1);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from ytcoode@gmail.com are


