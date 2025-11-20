Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EAA32FA11
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676273; cv=none; b=mmGlH8obzGV/Z6YNsbwkR7QDnXHxyQHErudula840EsiTXoBxXkUIRIrnz6/31k2DzAT0Wp92YG8qIanWMmKFP6ARIVzAddNYkanc86HacPiCKIeOrba8ztvD0KAk4TrWCUn+rgU2GSoSh/wY2RtLhOiIrcR1UegnF2og0llkxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676273; c=relaxed/simple;
	bh=npd2dzCdnjGh4h7bBHsYJw980xAQYI5jsOfcVPSd5jE=;
	h=Date:To:From:Subject:Message-Id; b=B5wG8S0HRdkSVaGM/2AEicgfrBxZ6SdVceZmrV+lFybPK7V0kCZJdEtTU+D/fob+7wIFslvstkrI13iSbs5XSU/VsTNlDp1Pkl7xjRnMghMJXzKJ4jHU1QC0oS00ID6fP1Y9z/TRh/xRzlmurUr1+MMemu78bQ4RIRVyWQpF3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vr6JcidS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vr6JcidS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E171C4CEF1;
	Thu, 20 Nov 2025 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676273;
	bh=npd2dzCdnjGh4h7bBHsYJw980xAQYI5jsOfcVPSd5jE=;
	h=Date:To:From:Subject:From;
	b=vr6JcidS5S/2rj/Hgj1wFz8L1/Ebm5ZebGbmOlAGKp5SkJOMeaNQJWTJqMjJVZv8u
	 CzqOezZ2SqkdeVTGiM/S1OHsXiv7i6TC7XMueDW3kfAL4NAUS924y0i/oz4E3W0XES
	 OUpFZj50CUKT63wTLIA9dNUdK2QgZEpeDYe7E8FA=
Date: Thu, 20 Nov 2025 14:04:32 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-myself-as-a-reviewer-for-kho.patch removed from -mm tree
Message-Id: <20251120220433.5E171C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Pratyush as a reviewer for KHO
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-reviewer-for-kho.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add Pratyush as a reviewer for KHO
Date: Wed, 5 Nov 2025 11:20:19 +0100

I have been reviewing most patches for KHO already, and it is easier to
spot them if I am directly in Cc.

Link: https://lkml.kernel.org/r/20251105102022.18798-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-reviewer-for-kho
+++ a/MAINTAINERS
@@ -13791,6 +13791,7 @@ KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-test_kho-to-khos-entry.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch
kho-free-chunks-using-free_page-instead-of-kfree.patch
test_kho-always-print-restore-status.patch

