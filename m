Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD612727FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762225861; cv=none; b=FlSB9IBef+SfpjYaRlNVifnzCnvP78wyZYrOeIJBbvWpgInhh+qJd64DvR+1TvS7Z6A+lHPvqejF76jqNM63yXxQgFA9I3WbXhuSQbMZPFl55XyTgGlLOgH0GXMc2cpMDJW4geuRvrsvxoVqU+h06LAGVQOyTaNOuYzvp+/UsUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762225861; c=relaxed/simple;
	bh=saOs6ufkCewRbyA1SEfTn6Ht/jiLTZ4OCrLov48tpRk=;
	h=Date:To:From:Subject:Message-Id; b=dpCKVvvl5/NNenFDGRYj85Jr8c/HGbb+Ua1QevflGwF66O6Wi2VtushSjf7WokqStUPwUEw6ojNXm87c67pjvs0GTTswWSdybDHphPTxaGZhi3xRTrKELuCS/IomIlMaWspwqXo046fc27znGCqV6XuITmM+Lx1hdnGTDvnXJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HsoiJm+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HsoiJm+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDC1C116C6;
	Tue,  4 Nov 2025 03:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762225860;
	bh=saOs6ufkCewRbyA1SEfTn6Ht/jiLTZ4OCrLov48tpRk=;
	h=Date:To:From:Subject:From;
	b=HsoiJm+MIu6nwnyk25i0YZjMF9In2/DXQ3zv28eu9Ct0OgGBf4TZil+O7SnLkLyOH
	 ALi8lkII+cgboepVPs+jfknZJBggaI7JVEQWM1s0Ygg0pidIqDFmlPJp9b8lwpG3Tg
	 Oiru9qjWOxiWaB6mhv864yuAV8UPjE6WCoSIgiTM=
Date: Mon, 03 Nov 2025 19:10:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,dan.j.williams@intel.com,apw@canonical.com,clopez@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-idr-to-the-deprecated-list.patch added to mm-nonmm-unstable branch
Message-Id: <20251104031100.9CDC1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add IDR to the deprecated list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-idr-to-the-deprecated-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-idr-to-the-deprecated-list.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: : Carlos López <clopez@suse.de>
Subject: checkpatch: add IDR to the deprecated list
Date: Fri, 31 Oct 2025 12:19:09 +0100

As of commit 85656ec193e9, the IDR interface is marked as deprecated in
the documentation, but no checks are made in that regard for new code. 
Add the existing IDR initialization APIs to the deprecated list in
checkpatch, so that if new code is introduced using these APIs, a warning
is emitted.

Link: https://lkml.kernel.org/r/20251031111908.2266077-2-clopez@suse.de
Signed-off-by: Carlos López <clopez@suse.de>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-idr-to-the-deprecated-list
+++ a/scripts/checkpatch.pl
@@ -860,6 +860,10 @@ our %deprecated_apis = (
 	"kunmap"				=> "kunmap_local",
 	"kmap_atomic"				=> "kmap_local_page",
 	"kunmap_atomic"				=> "kunmap_local",
+	#These should be enough to drive away new IDR users
+	"DEFINE_IDR"				=> "DEFINE_XARRAY",
+	"idr_init"				=> "xa_init",
+	"idr_init_base"				=> "xa_init_flags"
 );
 
 #Create a search pattern for all these strings to speed up a loop below
_

Patches currently in -mm which might be from clopez@suse.de are

checkpatch-add-idr-to-the-deprecated-list.patch

