Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D58F1E282D
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719332; cv=none; b=Lg0z0+3r0DIslJIDLVZ32G49qgh6doCU+5GbeVqUolrOyVGEPF7BcB+iV03LIR2tppJgD7317x+ut2A0mZBzDeilKrbysOOaSuuT1J3ZDue0cp5BKuiX19/TGU4HvHPOQooT1/RmN2zAG/LagJdNEovWg03uZwjoQ7J+bxl3yqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719332; c=relaxed/simple;
	bh=jOiyQJOMlvwNc25P1axrHBJrhtQegcfzjkmQKCTIL70=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Pa6WbzW+ani6jepllDL5EkNtVcUlMZUQOXGmJ+Va2pbi1xdci1uqZkkBh4WnxvuYNR5WGNUD0S0NLnPu9QKNBYpnvHqG9o/xnlmIXqJF5URgqVsY4MWW6EK0Ybg/SPWY6C8Wi/h4KfvTZil7TfZcaYNHhNvMt1DbEUxmVovr7i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tLyO38LF; arc=none smtp.client-ip=211.189.100.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tLyO38LF"
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20250508154848usoutp0243dbea84265a8e1ca2ce0a09c945c652~9l-luGIv91642816428usoutp02U;
	Thu,  8 May 2025 15:48:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20250508154848usoutp0243dbea84265a8e1ca2ce0a09c945c652~9l-luGIv91642816428usoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746719328;
	bh=qFKCiU6iDbqRnh5RyvkqkwbumVnmFs7WlVBV0zJVUd4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=tLyO38LF8cFCZqZwdu6yh5utpY9kOlyet23BwuKeCcRLbA909tP3qNffD/5Lc0xmz
	 uNNiv7pV4NUIl9yPEIEEQyjIdt9lW69wl9z21ePyaWkSbQhjAZitZSMFczSmXXtHtV
	 CZzcOpvz/5YXGgInrp/VQsvbpJgAG5oO3fJI1haU=
Received: from ussmtxp1.samsung.com (u136.gpu85.samsung.co.kr
	[203.254.195.136]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250508154847uscas1p2781145e2e75bee5f4b88ef8fd358ae2f~9l-lN-Uqk0446004460uscas1p29;
	Thu,  8 May 2025 15:48:47 +0000 (GMT)
Received: from ATXPVPPTAGT04.sarc.samsung.com (unknown [105.148.161.8]) by
	ussmtxp1.samsung.com (KnoxPortal) with ESMTP id
	20250508154847ussmtxp12eba5d53c3ae8426eb46f527dd2ab6b2~9l-lEqbNG1263212632ussmtxp1H;
	Thu,  8 May 2025 15:48:47 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT04.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT04.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548CU7UH030513; Thu, 8 May 2025 10:48:47 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT04.sarc.samsung.com (PPS) with ESMTP id 46df5w3vs0-2; Thu, 08 May
	2025 10:48:46 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 10:48:44 -0500
Date: Thu, 8 May 2025 18:48:39 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: David Hildenbrand <david@redhat.com>
CC: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	<mm-commits@vger.kernel.org>, <wade.farnsworth@siemens.com>,
	<jhubbard@nvidia.com>, <jgg@ziepe.ca>, <c.briere@samsung.com>,
	<artem.k@samsung.com>, David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508184839.482ca6cb@sarc.samsung.com>
In-Reply-To: <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
Organization: SARC
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: au1ppexchange01.sarc.samsung.com (105.148.32.81) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
X-Proofpoint-GUID: HGktRxFqiJIVbPoNT0w0aXSC5Ib_eQsW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDEzNyBTYWx0ZWRfXxT1rZFDCG2AZ
	BKf/zainzLxNm4uILq5rNr6N/mSEOqh2ffJlkrfgWOa5AUt7V3KznaWqgN40rQgCCHlSyoHEcd1
	mbpk2JJkI0jsS5qkViK3OzAd1Xevi8lycZMfeJyiiFEN6wCcTG/wnevHm4m84KJ3k6rh7qpSfjV
	H8U4OIhtT2mXONhtRvBX5PyDUAcBGO4aPQgv/lFWY7/IBqCmLloM/vWlrS+tGqZVz2rlhWaqspC
	OFlA1Qh9qqDgaV9YK49ar/cZgfT69hMNPPQw3e7D/O+aweTLPvZe+Z4icAasfj62tRXBy+y3q2G
	TPO5gsva85Oy+j2ifaf3pudWq5EMZJeWgq3ySijfHZBlIJJs/rVYsyNZ0Tpc7HMbqlNGiGUiqOx
	qQsI5fIv
X-Proofpoint-ORIG-GUID: HGktRxFqiJIVbPoNT0w0aXSC5Ib_eQsW
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-08_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
	priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
	lowpriorityscore=0 phishscore=0 clxscore=1015 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080137
X-CMS-MailID: 20250508154847uscas1p2781145e2e75bee5f4b88ef8fd358ae2f
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
	<aBzI3sl6r3HtAWP4@x1.local>
	<cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
	<20250508182718.40f16121@sarc.samsung.com>
	<e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>

On Thu, 8 May 2025 17:40:15 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 08.=E2=80=8A05.=E2=80=8A25 17:=E2=80=8A27, Pantelis Antoniou wrote: > =
On Thu, 8 May 2025
> 17:=E2=80=8A10:=E2=80=8A10 +0200 > David Hildenbrand <david@=E2=80=8Aredh=
at.=E2=80=8Acom> wrote: > >>
> On 08. 05. 25 17: 08, Peter Xu wrote: > On Thu, May 08, 2025 at 05:
> On 08.05.25 17:27, Pantelis Antoniou wrote:
> > On Thu, 8 May 2025 17:10:10 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >=20
> >> On 08.=E2=80=8A05.=E2=80=8A25 17:=E2=80=8A08, Peter Xu wrote: > On Thu=
, May 08, 2025 at 05:
> >> 36:=E2=80=8A12PM +0300, Pantelis Antoniou wrote: >> On Thu, 8 May 2025=
 10:
> >> 16:=E2=80=8A31 -0400 >> Peter Xu <peterx@=E2=80=8Aredhat.=E2=80=8Acom>=
 wrote: >> >> Hi
> >> Peter,
> >=20
> >> On 08.05.25 17:08, Peter Xu wrote:
> >>> On Thu, May 08, 2025 at 05:36:12PM +0300, Pantelis Antoniou wrote:
> >>>> On Thu, 8 May 2025 10:16:31 -0400
> >>>> Peter Xu <peterx@redhat.com> wrote:
> >>>>
> >>>> Hi Peter,
> >>>
> >>> Hi, Pantelis,
> >>>
> >>> [...]
> >>>
> >>>>>> @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
> >>>>>>    	int foreign =3D (gup_flags & FOLL_REMOTE);
> >>>>>>    	bool vma_anon =3D vma_is_anonymous(vma);
> >>>>>>   =20
> >>>>>> -	if (vm_flags & (VM_IO | VM_PFNMAP))
> >>>>>> -		return -EFAULT;
> >>>>>
> >>>>> Is there's any justification that this won't break some existing
> >>>>> GUP users that may rely on properly failing at pfnmaps?
> >>>>>
> >>>>> IIUC netfs isn't the first one that wants to GUP on top of
> >>>>> pfnmaps, KVM does it for years and so far it was processed in a
> >>>>> standalone path:
> >>>>>
> >>>>> hva_to_pfn:
> >>>>> 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> >>>>> 		r =3D hva_to_pfn_remapped(vma, kfp, &pfn);
> >>>>>
> >>>>> That started with supporting real pfnmaps (with no page struct),
> >>>>> but pfnmap with page structs can also happen afaict, and kvm
> >>>>> processes that too by checking page=3D=3DNULL ultimately, e.g. in
> >>>>> kvm_release_faultin_page().
> >>>>>
> >>>>
> >>>> I see. The problem is that we're not the owners of the code in
> >>>> netfslib, and it is considerably more intrusive to fix things
> >>>> there.
> >>>>
> >>>> This is a hotfix for a userspace regression. I sort of agree that
> >>>> having different handling for these areas in netfslib would be
> >>>> ideal.
> >>>
> >>> Do you mean this used to work in older kernels?  Some more info on
> >>> the regression would be more than welcomed if so..  If it fixes a
> >>> kernel regression, we may want a Fixes for whatever patch at last.
> >>
> >> To be precise: Whoever decided to use remap_pfn_range() essentially
> >> decided that GUP cannot possibly work.
> >>
> >> So is the regression introduced by a conversion to
> >> remap_pfn_range() in some code, or because suddenly someone relies
> >> on GUP for these things?
> >>
> >=20
> > I don't think there was a deliberate decision here, but there was no
> > conversion to remap_pfn_range(), the code (in DRM) was always there.
> >=20
> > The regression occurred when netfslib started using GUP for I/O and
> > when filesystems switched to it we hit this case.
>=20
> Okay, so GUP and DRM always worked that way. They are essentially=20
> incompatible at this point due to VM_PFNMAP.
>=20
> So netfslib requesting something that is impossible is the problem ..
> or rather filesystems switching to that and not realizing the problem.
>=20

All of the statements above are true.

> Hmmm
>=20

Indeed.
