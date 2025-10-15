Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17A24A08
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 02:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760496616; cv=none; b=cEQXiPlvfLorq2N7NtqrasfoadrQE7lyjEutf2V5ph4+eJZoHhKG/c9N9VcshFAFuh7nhf5GzexqO4139rX7GCXYZJI5t5v8QiI9PgoqJTDBCzJ1OHNotaUWY1+nMrlD9UtlzcWd7siD7A+Jf0LgT2pdnQDw2Qy3D5VPhgFXR0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760496616; c=relaxed/simple;
	bh=0r4j+sSFC6Ta303F1acgB3V2B5ruLyVpUmuXIh1cipk=;
	h=Date:To:From:Subject:Message-Id; b=ObfdOF6NAdPgqgvqEehybqjCpprXvuQGlo/e+F1RQnHJatjEFwIcIWMnhAFgdtyK3pvSDpLgjrco729N08qVi5lzQ4/1TMbFAEMiCbYEPmYz853/luVDnlxPXcnXItWuYzsASAtL2LErCC/ijopahVRijOmjMF7VK3GldOakelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SScEqlWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SScEqlWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2691BC4CEF1;
	Wed, 15 Oct 2025 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760496615;
	bh=0r4j+sSFC6Ta303F1acgB3V2B5ruLyVpUmuXIh1cipk=;
	h=Date:To:From:Subject:From;
	b=SScEqlWpql6aAC9zo4LzQthMQ1R31UdfJs17/+GT7MCAavvglGHJGiIu6zr613n+y
	 sBUbC29SEONHQWR3BMidRQ3vdKMXHZz4TSpo2Pap0rxZVfoZR3I5l5kGHyvGzfh+Ij
	 MgjYCq7xpT+fY4vkkAV+5rCcz0WqFRSpoRzdh7Ic=
Date: Tue, 14 Oct 2025 19:50:14 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,dan.carpenter@linaro.org,corbet@lwn.net,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-kho-move-to-kernel-liveupdate-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251015025015.2691BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-kho-move-to-kernel-liveupdate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-kho-move-to-kernel-liveupdate-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: liveupdate-kho-move-to-kernel-liveupdate-fix
Date: Tue Oct 14 07:46:59 PM PDT 2025

fix kho_preserve_vmalloc ENOMEM return, per Dan

Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~liveupdate-kho-move-to-kernel-liveupdate-fix
+++ a/kernel/liveupdate/kexec_handover.c
@@ -974,8 +974,10 @@ int kho_preserve_vmalloc(void *ptr, stru
 		chunk->phys[idx++] = phys;
 		if (idx == ARRAY_SIZE(chunk->phys)) {
 			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk)
+			if (!chunk) {
+				err = -ENOMEM;
 				goto err_free;
+			}
 			idx = 0;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch

