Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB27D276054
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718050; cv=none; b=d2JgSJLnnq355R7AbpzCe4RgT2Ydsh/wvgOkddwuKxOY/ft3hKwvvn3PYML1LPIsl2rHYXZHE4iWNgg8ohS5LZGKGz7noBhDhr/vczCTlmJpc02Yq8HAVXS4O2kULwHTy86dwa9Q3jVSBYqfZOyNPHPSanzv9qQHyCQisMIPHcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718050; c=relaxed/simple;
	bh=nzQY/bT2E3kUMWC3oAUWPI9p8TDRGrhnKDqBWpPUIDo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=OUOcY4cffXp9N6rX7yxkr9CS2RJotzqt1QEjflDGgrGGI1Ck/Di4g7T/UvXN3dp6EAy6Dvg0TsSM/N2ipL4wYDS0aTbYiPDousXX17sqaCCmkINtbCFJ3Y7byfKriMfSv/kYuKSrE14srzqy+JSQh9PvSVWddP9g5KFHEnHWh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=H6fnW8oO; arc=none smtp.client-ip=211.189.100.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="H6fnW8oO"
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20250508152726usoutp02b3a08c4b6e187c0a092307ef6d13ad8f~9ls8UFd0_0043200432usoutp02Q;
	Thu,  8 May 2025 15:27:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20250508152726usoutp02b3a08c4b6e187c0a092307ef6d13ad8f~9ls8UFd0_0043200432usoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746718046;
	bh=kOiBosEt4l3L3k4zL81jTVNCD2Hm8lUbu+Vu15ZEDas=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=H6fnW8oOZHhmpBIp0ER4DfSEJrHAOPpyJzT4tHM8q/lEu+ql034gguER8QCiS8D3g
	 INHKIe+tgjNTGMKJliRRofQGEVXhfYX/6GtXcWmTvbV8tDp4KMgeOEnrIwL8yga6Pb
	 Fhg+dUQXbM3TKHCEkM6A79O5GZy9TyTQa1Y+4znU=
Received: from ussmtxp2.samsung.com (u137.gpu85.samsung.co.kr
	[203.254.195.137]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250508152726uscas1p10c41b6b081455bc9f42be7f70e897be5~9ls78kwf32980629806uscas1p1N;
	Thu,  8 May 2025 15:27:26 +0000 (GMT)
Received: from ATXPVPPTAGT03.sarc.samsung.com (unknown [105.148.161.7]) by
	ussmtxp2.samsung.com (KnoxPortal) with ESMTP id
	20250508152726ussmtxp2947e4c224bb6a2825ec684e5ce68ad96~9ls7zT4pY1721317213ussmtxp2L;
	Thu,  8 May 2025 15:27:26 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT03.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT03.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548DSJob000623; Thu, 8 May 2025 10:27:25 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT03.sarc.samsung.com (PPS) with ESMTP id 46df5wbv82-1; Thu, 08 May
	2025 10:27:25 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 10:27:23 -0500
Date: Thu, 8 May 2025 18:27:18 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: David Hildenbrand <david@redhat.com>
CC: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	<mm-commits@vger.kernel.org>, <wade.farnsworth@siemens.com>,
	<jhubbard@nvidia.com>, <jgg@ziepe.ca>, <c.briere@samsung.com>,
	<artem.k@samsung.com>, David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508182718.40f16121@sarc.samsung.com>
In-Reply-To: <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
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
X-ClientProxiedBy: au1ppexchange03.sarc.samsung.com (105.148.32.83) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
X-Proofpoint-GUID: Ivh8ITtIf9x_kRcbZ7H6YEGFQH32dzBk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDEzMyBTYWx0ZWRfX5tbHgRu5DdF1
	rt2vbYCZPCQemlOmtPedQnJ3Th70T6RahHciOdmn07CfFMys3eJKzM8DMovq21KRJfkplkuMHdO
	D5sbijIC3hX3UYhUq0NOuha1kRP+9qEiMnNv2MCH3nmUkPDrcjACVgBt4XdYobGf0iqqtQ95z22
	KHFvSHiAgfeBQJchvoCChwbnAjZM3/U/DSUUJ5KtMYjU+18aE35PPStsc6DMGKlD6pQc07Er72t
	NxnI+OE+Zqv4+S+YE+H8YXc0iw0M06+cAFhYHmVGOqACOhVyjhvPx3T2yxFPP/pamcto1kQBYM3
	TKAZV7YeMnVsP3IATNmsjSmsrzTAXLYqYp1580uyTJneXUp5ipLmKsnbMlEq4cU9GWLvahaxKYh
	4f7YJhY+
X-Proofpoint-ORIG-GUID: Ivh8ITtIf9x_kRcbZ7H6YEGFQH32dzBk
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
	lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0
	mlxlogscore=999 adultscore=0 suspectscore=0 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080133
X-CMS-MailID: 20250508152726uscas1p10c41b6b081455bc9f42be7f70e897be5
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
	<aBzI3sl6r3HtAWP4@x1.local>
	<cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>

On Thu, 8 May 2025 17:10:10 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 08.=E2=80=8A05.=E2=80=8A25 17:=E2=80=8A08, Peter Xu wrote: > On Thu, M=
ay 08, 2025 at 05:
> 36:=E2=80=8A12PM +0300, Pantelis Antoniou wrote: >> On Thu, 8 May 2025 10:
> 16:=E2=80=8A31 -0400 >> Peter Xu <peterx@=E2=80=8Aredhat.=E2=80=8Acom> wr=
ote: >> >> Hi Peter,

> On 08.05.25 17:08, Peter Xu wrote:
> > On Thu, May 08, 2025 at 05:36:12PM +0300, Pantelis Antoniou wrote:
> >> On Thu, 8 May 2025 10:16:31 -0400
> >> Peter Xu <peterx@redhat.com> wrote:
> >>
> >> Hi Peter,
> >=20
> > Hi, Pantelis,
> >=20
> > [...]
> >=20
> >>>> @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
> >>>>   	int foreign =3D (gup_flags & FOLL_REMOTE);
> >>>>   	bool vma_anon =3D vma_is_anonymous(vma);
> >>>>  =20
> >>>> -	if (vm_flags & (VM_IO | VM_PFNMAP))
> >>>> -		return -EFAULT;
> >>>
> >>> Is there's any justification that this won't break some existing
> >>> GUP users that may rely on properly failing at pfnmaps?
> >>>
> >>> IIUC netfs isn't the first one that wants to GUP on top of
> >>> pfnmaps, KVM does it for years and so far it was processed in a
> >>> standalone path:
> >>>
> >>> hva_to_pfn:
> >>> 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> >>> 		r =3D hva_to_pfn_remapped(vma, kfp, &pfn);
> >>>
> >>> That started with supporting real pfnmaps (with no page struct),
> >>> but pfnmap with page structs can also happen afaict, and kvm
> >>> processes that too by checking page=3D=3DNULL ultimately, e.g. in
> >>> kvm_release_faultin_page().
> >>>
> >>
> >> I see. The problem is that we're not the owners of the code in
> >> netfslib, and it is considerably more intrusive to fix things
> >> there.
> >>
> >> This is a hotfix for a userspace regression. I sort of agree that
> >> having different handling for these areas in netfslib would be
> >> ideal.
> >=20
> > Do you mean this used to work in older kernels?  Some more info on
> > the regression would be more than welcomed if so..  If it fixes a
> > kernel regression, we may want a Fixes for whatever patch at last.
>=20
> To be precise: Whoever decided to use remap_pfn_range() essentially=20
> decided that GUP cannot possibly work.
>=20
> So is the regression introduced by a conversion to remap_pfn_range()
> in some code, or because suddenly someone relies on GUP for these
> things?
>=20

I don't think there was a deliberate decision here, but there was no
conversion to remap_pfn_range(), the code (in DRM) was always there.

The regression occurred when netfslib started using GUP for I/O and
when filesystems switched to it we hit this case.

Regards

-- Pantelis
