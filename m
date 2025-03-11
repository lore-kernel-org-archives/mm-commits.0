Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7C320F
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 05:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741671294; cv=none; b=C0ek+feluGq98I+3s7VGEOydfTpyj11gGPFxg+7cIWjopVDiwgaODYpe94CiluE5HQpEdW9cX633nnBw4tqriTpddPAmi+ZfBFIJk7ltSeOtqhrKrOW+SLV+Olu4E1tuHGpk2hlAB2EbpXdQWZbcF+sCIuj79eCyxXKXatsFdu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741671294; c=relaxed/simple;
	bh=app1R9HjOHvqjoOrlc3hQVIUVv1CiZkSLUl8qA7DDGI=;
	h=Date:To:From:Subject:Message-Id; b=Scqk/QsOLPQuMVg5zJSYgd5Krl46EWJAtnvj6yvVbSSKTkPFn3zknUwYPMYHKz4wYeHUMcCTCvmLJnzKljpMD0p8qI4x+ea7dvtLBx95RMjg2uJcb7N+xovSpow2TjgfFaWxoomJJ/ztQOIi6uLnjsrC0ZAWvw7ddAwIk083dWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFAjOPqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFAjOPqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A270DC4CEE9;
	Tue, 11 Mar 2025 05:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741671293;
	bh=app1R9HjOHvqjoOrlc3hQVIUVv1CiZkSLUl8qA7DDGI=;
	h=Date:To:From:Subject:From;
	b=HFAjOPqqDwpfhDZ+XGD9MyVI/Mi1hyOAzmuZlPqQmFAB3qLoOimjsV1/Z8Emx4aCU
	 545FRYEDg2e6xU3uNC78VK0FP5Ka3KH8Cq9D7JqSwf44zc6KsKjufqbJ3GSOGQQ/l+
	 NPe061hgBHpQrSC0+ixwKvUz/wJHjJNYrpPKnmAA=
Date: Mon, 10 Mar 2025 22:34:52 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,sj@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch added to mm-unstable branch
Message-Id: <20250311053453.A270DC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/sysfs-schemes: avoid Wformat-security warning
Date: Mon, 10 Mar 2025 14:51:37 +0100

This warning is for potentially user-defined format strings:

mm/damon/sysfs-schemes.c:1664:4: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
 1664 |                         name);

Change this to use "%s" as the format and the name as the argument.

Link: https://lkml.kernel.org/r/20250310135142.4176976-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1616,7 +1616,7 @@ static int damon_sysfs_scheme_set_filter
 		return -ENOMEM;
 	err = kobject_init_and_add(&filters->kobj,
 			&damon_sysfs_scheme_filters_ktype, &scheme->kobj,
-			name);
+			"%s", name);
 	if (err)
 		kobject_put(&filters->kobj);
 	else
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

