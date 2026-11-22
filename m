Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795305639;
	b=mRFz9WtCxjlQb2q8GnBB6CEM2Pcedcv9iFaKmly6CYD/hMZWkoj+ZW9vGr3pMkkYyRyy
	 +ss7nvYMK3EeUc3Ri8NC+15u/Crb9PZvSFdT56ljDBV4MFKa1p9xB7kzKYBSVZ307qdM7
	 /rmhQlZ48FJxJBL4qw/7RkRpA8pNEQwbPQD/739DHRq7KP72+mHm/7dT91SBrB/Ls7mf5
	 eJnAzXGXKOoadfEoAiHAVPPs11i794OtB8rhQ+CNRIDZxreIgO/zV8cRb5tTK0VKpDc1A
	 tktru4314HzgCRiEsyuI4U16jBVsY1+mZf9Ka2KeBxPtK77m9e1MofveTT6D3LurGew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795305639;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=04EqnkPwf0WubK8I3U0HutElecdyfT91xsPRhXdRrm8=;
	b=y+xKI55+TuDXrpn3l7fHPN3Cms8SqpFX9kimazQtGtEvLp+RgVKcv/nK54Bf4fkCkc7l
	 9wjgTmgxXTzC91p9eoVP9GfHDAPuN7pFDpv9IQhgBA6bafNNzVeTyy0uPdkC6JkAPJ8wX
	 pMcH4w6Eo6o338IToBFRUOGkoTCtFFF0W9gzkPxdYpqDBROMnjqE88zxBbHyd0/xGuEIP
	 FsnDYU+A3vIdcljMnliKNshWo2MOYkQdVUF+xOseZvd8hdeSj+fAJSUQ/sGeLW/xIEKvK
	 UHxsqiOrDrYxQ/rr23oGDeBkQtydLFsWrSyx3OQ4QBW0HxEQubMQTfrZW9YqZwRd3FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2aQbeKX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4428606A320;
	Sun, 22 Nov 2026 00:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2aQbeKX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F7A1F000C4;
	Sun, 22 Nov 2026 00:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795305638;
	bh=04EqnkPwf0WubK8I3U0HutElecdyfT91xsPRhXdRrm8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L2aQbeKX/CTPckpuCxg/75CkYq7VgqRjjwXERlHfP3ef/xH4jzlR1llKSlU5CeM8e
	 gUoqibFABjeIaklQZ6WRqldqwgKZ5YTZ1h3Bi7puox1t9KLDvG/77rmYY7BqGwgQDR
	 LhWKY3luEuf/ybIxy+nQvMG6VZ1ez9KdmhG98Da8=
Date: Sat, 21 Nov 2026 16:00:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: jgg@nvidia.com, leonro@nvidia.com, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost
 <matthew.brost@intel.com>, mm-commits@vger.kernel.org, mpenttil@redhat.com,
 Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park
 <sj@kernel.org>, thomas.hellstrom@linux.intel.com, Vlastimil Babka
 <vbabka@suse.cz>, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
In-Reply-To: <179342234355.4.16705453209886955762@gmail.com>
References: <179342234355.4.16705453209886955762@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Oct 2026 15:07:58 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> When a query starts inside a device-private PMD owned by
> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
> array from the folio's first page. The returned PFNs therefore refer to
> earlier pages rather than the requested subrange.
>=20
> Add the query's PMD-relative page offset to the initial PFN, as the
> present PMD path already does.
>=20
> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
>=20
> ---
> Found during a synthetic test_hmm check of device-private THP handling.
> Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
> PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
> executed tests passed with the fix. No real GPU testing was performed.

Thanks.  It appears that the changelog somewhat understates the
seriousness of this so I came up with a more assertive one, below.=20
Please check that.

I fed this through LLM-driven QEMU-based runtime testing and it looks
like it pretty much replicated your testing:

: I tested "mm/hmm: account for subpage offsets in device-private
: PMDs" on matched x86-64 guest kernels. An unprivileged process
: (UID 65534) migrated an anonymous 2 MiB THP to the test_hmm
: device. A second open of the device read pages inside the PMD
: while the first remained open. A snapshot confirmed a
: device-private PMD, and temporary kernel log messages confirmed
: that the reads reached hmm_vma_handle_absent_pmd().
:=20
: Without the patch, requests for pages 1, 7, 255 and 511 returned
: page 0. A request for pages 31-33 returned pages 0-2. With the
: patch, all seven pages returned the requested contents. Page 0
: read correctly on both kernels. Thus an unprivileged device user
: can receive data from the wrong pages.
:
: The fake device needed an identical temporary backing-page
: correction on both kernels to make this read path work. That
: change was removed after testing. This exercises the HMM path
: through test_hmm; I did not test GPU hardware.

So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
put a device-private page into its page table, then dmirror_do_read()
tries to copy from that non-CPU-accessible page and oopses".  I'll prep
a fix for that separately.



I'll queue the below in mm.git's mm-hotfixes queue and shall await
maintainer input (please).


From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/hmm: account for subpage offsets in device-private PMDs
Date: Sat, 31 Oct 2026 15:07:58 +1100

When a query starts inside a device-private PMD owned by
range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
array from the folio's first page.  The returned PFNs therefore refer to
earlier pages rather than the requested subrange.

Nouveau's GPU fault path can query one page of a device-private PMD at a
time.  Xe's SVM fault, prefetch and userptr mapping paths can also query
subranges of their own device-private PMDs.  An unprivileged process with
access to the GPU render node can reach these paths on hardware supporting
device-private THP migration.  Xe can read the wrong application data or
silently overwrite earlier pages of the same process's device-private
folio.

Nouveau aligns a one-page GPU fault to the PMD head by subtracting the
fault offset from the returned page.  The faulty HMM PFN already refers to
the head, so this subtraction can select a page before the folio.  If the
preceding page belongs to another allocation, GPU access can expose or
overwrite unrelated userspace data; an invalid page can also fault the
kernel during its address conversion.  This worst case follows from the
source, but has not been demonstrated on a real GPU.

Add the query's PMD-relative page offset to the initial PFN, as the
present PMD path already does.

The device-private PMD migration machinery first shipped in 6.19.=20
Backport this fix to the maintained 7.3.y stable series; the HMM path
exists in 6.18.y but cannot be reached through an in-tree PMD-producing
device-private migration path there.

Link: https://patch.msgid.link/179342234355.4.16705453209886955762@gmail.com
Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Patchwork <patchwork@emeril.freedesktop.org>
Cc: SJ Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Christian K=F6nig <christian.koenig@amd.com>
Cc: Mika Penttil=E4 <mpenttil@redhat.com>
Cc: Thomas Hellstr=F6m <thomas.hellstrom@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmm-account-for-subpage-offsets-in-device-private-pmds
+++ a/mm/hmm.c
@@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(str
 	    range->dev_private_owner) {
 		unsigned long cpu_flags =3D HMM_PFN_VALID |
 			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
-		unsigned long pfn =3D softleaf_to_pfn(entry);
+		unsigned long pfn =3D softleaf_to_pfn(entry) +
+			((start & ~PMD_MASK) >> PAGE_SHIFT);
 		unsigned long i;
=20
 		if (softleaf_is_device_private_write(entry))
_

