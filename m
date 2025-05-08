Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9406C272E5F
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746714985; cv=none; b=fLRwSaW+QfDcJoCleIpOuhNM+y7T8JfhPXm7K9eWeC5/NbW0BBZBB7m3FD0HS3XPgmn1mNMUdoJ8kvy+Dca2nHGbETZSNaD4JGLrx2DSyO7hpzmI5zOAkG0w6bGc5w8PshxyyjX4XQjXXOkhCg6gF2sBu16vfTIFR9pBUjCw8LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746714985; c=relaxed/simple;
	bh=hotmDSSRajSz8CG2x1RzOvs9Q7/3jC4PmiYz0FMamq8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=s8kXX4WGIj5oBUJwOUN9p1igIf5YQAtOSXe26eaXLLyHzbV1hpZlmXvcO4NhviyFHnn48W0xh3NRCigU5Q8/zgN+OLI+FaS3gC2uLM9jXNEADDhSmHTnWmooMZKh8ZmvDoRUNV0yjErjsugvt8bXMFq4Ku2Sv2v45/FHkBzp9ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FUW537jp; arc=none smtp.client-ip=211.189.100.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FUW537jp"
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20250508143620usoutp02f1072a077805b1de903116ac0d468d5c~9lAUgJGVT1600116001usoutp02e;
	Thu,  8 May 2025 14:36:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20250508143620usoutp02f1072a077805b1de903116ac0d468d5c~9lAUgJGVT1600116001usoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746714980;
	bh=tXdHmtGJYQUo6e/n5CoOx/BywcWXYQi+y3wyM5tYKoU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=FUW537jpwlpe1rHEzO0fVqHQzUrdvwpUANZIGD+djuuLuGCtzO4a4MtOI9IPm8Idd
	 l1FspVVB99TqwDCWuliAMUnKfxXPxOtbAUN/xvCztou1Paof5xLicmTxq/FuXWMV6i
	 XjHWOQy1wcFBmF8OVHgwaudiQ/wRH98Oqkqx+/vg=
Received: from ussmtxp2.samsung.com (u137.gpu85.samsung.co.kr
	[203.254.195.137]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250508143620uscas1p1f406b266087904a825f587c0e3d30e35~9lAUTpUCw1780517805uscas1p1_;
	Thu,  8 May 2025 14:36:20 +0000 (GMT)
Received: from ATXPVPPTAGT04.sarc.samsung.com (unknown [105.148.161.8]) by
	ussmtxp2.samsung.com (KnoxPortal) with ESMTP id
	20250508143619ussmtxp2d6544958fdc2c26eb603858d3c2ff801~9lAUKYbRd2807928079ussmtxp2v;
	Thu,  8 May 2025 14:36:19 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT04.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT04.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548DoQhP029455; Thu, 8 May 2025 09:36:19 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT04.sarc.samsung.com (PPS) with ESMTP id 46df5w3ua1-1; Thu, 08 May
	2025 09:36:19 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 09:36:16 -0500
Date: Thu, 8 May 2025 17:36:12 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: Peter Xu <peterx@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <jhubbard@nvidia.com>, <jgg@ziepe.ca>,
	<david@redhat.com>, <c.briere@samsung.com>, <artem.k@samsung.com>, David
	Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508173612.34d1bea3@sarc.samsung.com>
In-Reply-To: <aBy8v7gi3tsQ5-iy@x1.local>
Organization: SARC
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: au1ppexchange03.sarc.samsung.com (105.148.32.83) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: UO-bnfYVB1ewRDA58rcfBPepN2s3qP16
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDEyNCBTYWx0ZWRfX9TVQYraim8jm
	gAha5er2N8xW9tNUGxDBdmWaGNDdEYKFDqv/0E9FxT2y5DL+d7M3KBM2X+7i/NAHRlSicXRIcSl
	RQU+DvLRrmxi+wNRuJBM0vzk6HjXiV+tlIKlovIlRTYj4PeciHovUDYbJZNkN2e+joREynxp5I2
	jiFxxPvsU1O2S4knm9t6Fd3LxcAEv9VwMFLp75oZgqH/MU2eTV2TtmEyzPcfHVuFHQBOFMuWC3t
	6amJ5Jriv8akAPTdoXPPJiaC9WIBUUaB1NhWsAx7TT4bPDqEi/bVrZCU0sBlKRgXOlBr2tRiT0m
	WV2gSUBr1iE+uc9/wNsGEhhzo46o46+zB0kPj2TmRerhGy53jckfoMTjTwjk2mr4c+6Rat1wFYM
	Isejhrfm
X-Proofpoint-ORIG-GUID: UO-bnfYVB1ewRDA58rcfBPepN2s3qP16
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
	priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
	lowpriorityscore=0 phishscore=0 clxscore=1011 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080124
X-CMS-MailID: 20250508143620uscas1p1f406b266087904a825f587c0e3d30e35
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local>

On Thu, 8 May 2025 10:16:31 -0400
Peter Xu <peterx@redhat.com> wrote:

Hi Peter,

> Hi, Pantelis, [Cc David Howells] On Wed, May 07, 2025 at 02:=E2=80=8A55:=
=E2=80=8A54PM
> -0700, Andrew Morton wrote: > > The patch titled > Subject: Fix zero
> copy I/O on __get_user_pages allocated pages > has been added to the
> -mm mm-hotfixes-unstable=20
> Hi, Pantelis,
>=20
> [Cc David Howells]
>=20
> On Wed, May 07, 2025 at 02:55:54PM -0700, Andrew Morton wrote:
> >=20
> > The patch titled
> >      Subject: Fix zero copy I/O on __get_user_pages allocated pages
> > has been added to the -mm mm-hotfixes-unstable branch.  Its
> > filename is
> > fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
> >=20
> > This patch will shortly appear at
> >      https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/k=
ernel/git/akpm/25-new.git/tree/patches/fix-zero-copy-i-o-on-__get_user_page=
s-allocated-pages.patch__;!!KUh5zVML9r9m!2UOP9aM2VFq6hYqCdCsuJWGKqQ36OHuy8f=
OXVwFXktF6e9uH-2METAUSLAFHOPpOplI8gbkk7l6UAmauPPQ$
> >=20
> > This patch will later appear in the mm-hotfixes-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >=20
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >=20
> > *** Remember to use Documentation/process/submit-checklist.rst when
> > testing your code ***
> >=20
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >=20
> > ------------------------------------------------------
> > From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
> > Subject: Fix zero copy I/O on __get_user_pages allocated pages
> > Date: Wed, 7 May 2025 10:41:05 -0500
> >=20
> > Recent updates to net filesystems enabled zero copy operations,
> > which require getting a user space page pinned.
> >=20
> > This does not work for pages that were allocated via
> > __get_user_pages and then mapped to user-space via remap_pfn_rage.
> >=20
> > remap_pfn_range_internal() will turn on VM_IO | VM_PFNMAP vma bits.=20
> > VM_PFNMAP in particular mark the pages as not having struct_page
> > associated with them, which is not the case for __get_user_pages()
> >=20
> > This in turn makes any attempt to lock a page fail, and breaking
> > I/O from that address range.
> >=20
> > This patch address it by special casing pages in those VMAs and not
> > calling vm_normal_page() for them.
> >=20
> > Link:
> > https://urldefense.com/v3/__https://lkml.kernel.org/r/20250507154105.76=
3088-2-p.antoniou@partner.samsung.com__;!!KUh5zVML9r9m!2UOP9aM2VFq6hYqCdCsu=
JWGKqQ36OHuy8fOXVwFXktF6e9uH-2METAUSLAFHOPpOplI8gbkk7l6UcsZY8XI$
> > Signed-off-by: Pantelis Antoniou <p.antoniou@partner.samsung.com>
> > Cc: Artem Krupotkin <artem.k@samsung.com> Cc: Charles Briere
> > <c.briere@samsung.com> Cc: Wade Farnsworth
> > <wade.farnsworth@siemens.com> Cc: David Hildenbrand
> > <david@redhat.com> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >=20
> >  mm/gup.c |   22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> >=20
> &gt; ---
> a/mm/gup.c~fix-zero-copy-i-o-on-__get_user_pages-allocated-pages
> > +++ a/mm/gup.c
> > @@ -833,6 +833,20 @@ static inline bool can_follow_write_pte(
> >  	return !userfaultfd_pte_wp(vma, pte);
> >  }
> >=20=20
> > +static struct page *gup_normal_page(struct vm_area_struct *vma,
> > +		unsigned long address, pte_t pte)
> > +{
> > +	unsigned long pfn;
> > +
> > +	if (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)) {
> > +		pfn =3D pte_pfn(pte);
> > +		if (!pfn_valid(pfn) || is_zero_pfn(pfn) || pfn >
> > highest_memmap_pfn)
> > +			return NULL;
> > +		return pfn_to_page(pfn);
> > +	}
> > +	return vm_normal_page(vma, address, pte);
> > +}
> > +
> >  static struct page *follow_page_pte(struct vm_area_struct *vma,
> >  		unsigned long address, pmd_t *pmd, unsigned int
> > flags, struct dev_pagemap **pgmap)
> > @@ -858,7 +872,9 @@ static struct page *follow_page_pte(stru
> >  	if (pte_protnone(pte) && !gup_can_follow_protnone(vma,
> > flags)) goto no_page;
> >=20=20
> > -	page =3D vm_normal_page(vma, address, pte);
> > +	page =3D gup_normal_page(vma, address, pte);
> > +	if (page && (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)))
> > +		(void)follow_pfn_pte(vma, address, ptep, flags);
> >=20=20
> >  	/*
> >  	 * We only care about anon pages in can_follow_write_pte()
> > and don't @@ -1130,7 +1146,7 @@ static int get_gate_page(struct
> > mm_struc *vma =3D get_gate_vma(mm);
> >  	if (!page)
> >  		goto out;
> > -	*page =3D vm_normal_page(*vma, address, entry);
> > +	*page =3D gup_normal_page(*vma, address, entry);
>=20
> Is this really needed?  IIUC the iter code would only use in either
> UBUF or IOVEC ones.
>=20

I think you're right, for our platforms the gate check never passes.

However using the same gup_normal_page() method could be clearer in this
context.

> >  	if (!*page) {
> >  		if ((gup_flags & FOLL_DUMP) ||
> > !is_zero_pfn(pte_pfn(entry))) goto unmap;
> > @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
> >  	int foreign =3D (gup_flags & FOLL_REMOTE);
> >  	bool vma_anon =3D vma_is_anonymous(vma);
> >=20=20
> > -	if (vm_flags & (VM_IO | VM_PFNMAP))
> > -		return -EFAULT;
>=20
> Is there's any justification that this won't break some existing GUP
> users that may rely on properly failing at pfnmaps?
>=20
> IIUC netfs isn't the first one that wants to GUP on top of pfnmaps,
> KVM does it for years and so far it was processed in a standalone
> path:
>=20
> hva_to_pfn:
> 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> 		r =3D hva_to_pfn_remapped(vma, kfp, &pfn);
>=20
> That started with supporting real pfnmaps (with no page struct), but
> pfnmap with page structs can also happen afaict, and kvm processes
> that too by checking page=3D=3DNULL ultimately, e.g. in
> kvm_release_faultin_page().
>=20

I see. The problem is that we're not the owners of the code in netfslib,
and it is considerably more intrusive to fix things there.

This is a hotfix for a userspace regression. I sort of agree that having
different handling for these areas in netfslib would be ideal.

Or perhaps changing semantics by having an extra VM_* bit that would
mark that VMA as actually having a backing page struct. Dunno, things
could get considerably complex fast.

> The other thing is above only processed pte level of pfnmap, and just
> to mention pmd/pud may need attention too because we're gradually
> supporting huge mappings even for pfns.  I didn't check whether it's
> possible as of now, though.  Maybe it's not an immediate concern.
>=20

You are absolutely right, eventually it will be a concern in the future.

> In general, I'm uncertain about whether this is the right way to go so
> far. To me it might be less intrusive if we follow what kvm does for
> now, or maybe we also at least want to enrich the justification part
> in the commit log.
>=20

Again, this as a hotfix. An actual fix might be something that address
both KVM and netfslib concerns, but that would be something much
larger than a 20 line patch.

> >=20=20
> >  	if ((gup_flags & FOLL_ANON) && !vma_anon)
> >  		return -EFAULT;
> > _
> >=20
> > Patches currently in -mm which might be from
> > p.antoniou@partner.samsung.com are
> >=20
> > fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
> >=20
>=20

Regards

-- Pantelis
