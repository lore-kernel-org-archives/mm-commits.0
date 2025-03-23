Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798C199920
	for <mm-commits@vger.kernel.org>; Sun, 23 Mar 2025 01:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742691816; cv=none; b=pFXh5MtO4+QQ8BiHm4bYV+JQVFiS2U8Zk2XD+UDrWEqs0OfcE4bd/0ohLZ8uq7RozblHO814t2ZPCE67yLheoyzKwce9xpfx+RfPf5jONjfJrR7WF05/o2euR4erloKgEkcVdaEa+21cEvrR/H2+MDYutr0yMoW4U16vII+WltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742691816; c=relaxed/simple;
	bh=s9lOhoamNYXPEfRi3YsNDcAe8Xvwd3AR2NfX2asMqNU=;
	h=Date:To:From:Subject:Message-Id; b=X01TFL0TyP3tCqkMPcRJ8BzrRyu77aHbWhhOyGDSCySy6EVBcpJmLa48GfAt7n4LAH37sLlZg7YeXo4zpu7Xf2yCaP0R0A/8+pf26f6Yy3gYKzWPVYoMPPEo+Q8Y8wU+zP9hFNa01swCTOGfZN5MW7vEotU6RYTgYJea5qjMdeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tZDnyKgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZDnyKgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBC3C4CEDD;
	Sun, 23 Mar 2025 01:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742691813;
	bh=s9lOhoamNYXPEfRi3YsNDcAe8Xvwd3AR2NfX2asMqNU=;
	h=Date:To:From:Subject:From;
	b=tZDnyKgO9qCylS6xG3JDxlFcZr9zYmF/bild82AlqLBRorCborHsDNgDTlTxvm5vc
	 CZE2v5q2CqukAkQTssAivBtI9/CkJlcKajTB0QyQ3RY6eQHqp+9GMbC7ZvPY4LgB/W
	 VG6JIc5dvc2+/IRPU6Gyi3IOr1iIlLKHE+sFKowc=
Date: Sat, 22 Mar 2025 18:03:33 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-userfaultfd-reviewer-fix.patch added to mm-unstable branch
Message-Id: <20250323010333.CFBC3C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maintainers-add-myself-as-userfaultfd-reviewer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-userfaultfd-reviewer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-userfaultfd-reviewer-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-myself-as-userfaultfd-reviewer-fix
Date: Sat Mar 22 06:02:12 PM PDT 2025

add include/linux/userfaultfd_k.h, per Mike

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer-fix
+++ a/MAINTAINERS
@@ -15227,6 +15227,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/userfaultfd.rst
 F:	fs/userfaultfd.c
 F:	include/asm-generic/pgtable_uffd.h
+F:	include/linux/userfaultfd_k.h
 F:	include/uapi/linux/userfaultfd.h
 F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch
maintainers-add-myself-as-userfaultfd-reviewer-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

