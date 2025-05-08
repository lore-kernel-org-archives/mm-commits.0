Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E9281363
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727910; cv=none; b=h06MaB8DsLKuISp/p87UBc2k+Ic7nrryHlBe/0xqABSWnBsb2OYyTECeaFHbK5DQtUO8YlrlzvspRRifuvK9er8IaOYVYOppCILsF5ee6En+CeeJOCuPkyDxzzznO7Hazrl87koFt7O2WF4Yqtr90/8iPkTAOmXY+AewG9e/buA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727910; c=relaxed/simple;
	bh=83gHkZLaAs8AW4AJ9Og2c8PMWpi01r99CybTpx/lzFQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FfGdSuQfjmTGqEVJ1OIi7WcOPWJD2LQcj7pxcR50fDMOx3NFyGbWH2yKDUmz1udq503/vCaff5BCRkdpcXXJoLtic8Z3UCm/p3PkWP9nSDBT/z/QzMGpiU2wQ5r5/k29JvcdUZ1tAvPQJwBJOncmebyC2KjnFKffuDpuMgjfeEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cWvZ9rDF; arc=none smtp.client-ip=211.189.100.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cWvZ9rDF"
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20250508181143usoutp013095ebcd481711882a08447f31887ee8~9n8YYOFiy2025720257usoutp01O;
	Thu,  8 May 2025 18:11:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20250508181143usoutp013095ebcd481711882a08447f31887ee8~9n8YYOFiy2025720257usoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746727903;
	bh=83gHkZLaAs8AW4AJ9Og2c8PMWpi01r99CybTpx/lzFQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=cWvZ9rDFTcZ4gT6/a0etb4dwV5lqrfB83jR1VlOYdtjtNiHnG7DAr5+GYOXjSvdW2
	 Pa9aeqhwco9irPcYpjmG0iIsIL5oYcfWEBlEgbE+IycKUkWYRDdjTTEC0xL2ToUruz
	 El0am4erp/Hd6cWPmayUVEZwmO3dTO+OmrW1MbPU=
Received: from ussmtxp1.samsung.com (u136.gpu85.samsung.co.kr
	[203.254.195.136]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250508181143uscas1p188cd4ab4e50c318dc557fad9c0342526~9n8YFxApD2336923369uscas1p1Z;
	Thu,  8 May 2025 18:11:43 +0000 (GMT)
Received: from ATXPVPPTAGT03.sarc.samsung.com (unknown [105.148.161.7]) by
	ussmtxp1.samsung.com (KnoxPortal) with ESMTP id
	20250508181143ussmtxp149749fbbef220c12a5f1b05378065e76~9n8X8ddml0700407004ussmtxp1z;
	Thu,  8 May 2025 18:11:43 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT03.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT03.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548EOaae045334; Thu, 8 May 2025 13:11:42 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT03.sarc.samsung.com (PPS) with ESMTP id 46df5wbyhf-1; Thu, 08 May
	2025 13:11:42 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 13:11:40 -0500
Date: Thu, 8 May 2025 21:11:36 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: David Hildenbrand <david@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <jhubbard@nvidia.com>,
	<c.briere@samsung.com>, <artem.k@samsung.com>, David Howells
	<dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508211136.7a0a3865@sarc.samsung.com>
In-Reply-To: <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
Organization: SARC
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: au1ppexchange01.sarc.samsung.com (105.148.32.81) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: Gqdo19brJ6Qmo2VMI0oR2tMtcfw3EbKg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDE2MSBTYWx0ZWRfX1ClmtNdnV0Qi
	0uMtP5aHSS7xmkSjQ/Oa2Ihmw3EDbIkl++kvkPqsMehb9wEv0EwldO3nxhxGo3urOUPZ3V/yo2w
	Zvd19aWRqRfZRFeFzdCEEUNHCvZPhMmK0SuUMN0g5mVxEydAYvq05xRdeDoVc4GMnN1xRPa+2I2
	m9xaz0quD6diRwhe9xcEE8YKAwxE/+clHy2Yr8si14C0rfw2JvUsRDXyauVpCx3OIKQZg5+NuDr
	FVJE0o6bqVZGXcx5+bd2V2o8pJG5coDQgi/25VRLesdkCf8dlkzL6Bjym/7gm61k7xBZs4+tvAv
	eQpsd35YS0pnLikBb+6Y3oeDEzv5riOjbF5lMtJT/cu3NQ1v1U4P7mDjywidbWht/B6NtMs9eh5
	y8Q828Mz
X-Proofpoint-ORIG-GUID: Gqdo19brJ6Qmo2VMI0oR2tMtcfw3EbKg
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-08_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
	lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0
	mlxlogscore=999 adultscore=0 suspectscore=0 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080161
X-CMS-MailID: 20250508181143uscas1p188cd4ab4e50c318dc557fad9c0342526
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
	<aBzI3sl6r3HtAWP4@x1.local>
	<cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
	<20250508182718.40f16121@sarc.samsung.com>
	<e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
	<20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
	<1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>

On Thu, 8 May 2025 20:02:38 +0200
David Hildenbrand <david@redhat.com> wrote:

Hi David,

> On 08.=E2=80=8A05.=E2=80=8A25 19:=E2=80=8A47, Pantelis Antoniou wrote: > =
On Thu, 8 May 2025
> 14:=E2=80=8A35:=E2=80=8A35 -0300 > Jason Gunthorpe <jgg@=E2=80=8Aziepe.=
=E2=80=8Aca> wrote: > > Hi
> Jason, > >> On Thu, May 08, 2025 at 05: 40: 15PM +0200, David
> Hildenbrand wrote: >>>>=20
> On 08.05.25 19:47, Pantelis Antoniou wrote:
> > On Thu, 8 May 2025 14:35:35 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >=20
> > Hi Jason,
> >=20
> >> On Thu, May 08, 2025 at 05:=E2=80=8A40:=E2=80=8A15PM +0200, David Hild=
enbrand
> >> wrote:
> >>>> I don't think there was a deliberate decision here, but there was
> >>>> no > > conversion to remap_pfn_range(), the code (in DRM) was
> >>>> always there. > > > >
> >> On Thu, May 08, 2025 at 05:40:15PM +0200, David Hildenbrand wrote:
> >>>> I don't think there was a deliberate decision here, but there was
> >>>> no conversion to remap_pfn_range(), the code (in DRM) was always
> >>>> there.
> >>>>
> >>>> The regression occurred when netfslib started using GUP for I/O
> >>>> and when filesystems switched to it we hit this case.
> >>>
> >>> Okay, so GUP and DRM always worked that way. They are essentially
> >>> incompatible at this point due to VM_PFNMAP.
> >>>
> >>> So netfslib requesting something that is impossible is the problem
> >>> .. or rather filesystems switching to that and not realizing the
> >>> problem.
> >>>
> >>> Hmmm
> >>
> >> This patch definately doesn't look very good as is.
> >>
> >=20
> > No argument praising its beauty from me.
> > What is the right solution then?
> >=20
> >> We *certainly* should not be even trying to touch the struct page
> >> of a VMA_PFNMAP *at all*. By definition that is forbidden.
> >>
> >> It looks to me like vm_normal_page() already supports MIXEDMAP, so
> >> probably the better hotfix is to have DRM use MIXEDMAP if it is
> >> installing PFNs that it is willing to be used as struct page.
> >>
> >> But who knows if DRM can do that on arches that don't have
> >> PTE_SPECIAL..
> >>
> >=20
> > The question from me is why a __get_free_pages() area that is passed
> > to remap_pfn_range() gets the PFNMAP bit set.
>=20
> remap *PFN* range is the wrong interface. You literally tell the
> system "map a PFN range and ignore any struct page" instead of
> "please map this refcounted page".
>=20

I agree, but it's not my code that's doing it.
This has been going on for more than a decade at this point.

Can we get a plan on how to go around fixing these issues correctly?

1. Drivers/subsystems (DRM in this case) are doing remap_pfn_range() to
map system memory with a page attached to user space.
Up until recently this was OK, since no-one tried to pin the pages for
any reason. It doesn't seem like this is the right way to do it.
What is the right way?

2. DRM in particular has no standardized way to handle mapping system
memory Buffer Objects (BOs) to userspace. Each driver is free to do it's
own thing and does so. What is the right way to handle this case.

3. While we go about fixing it, this has caused a pretty significant
userspace regression, where the address space that those BOs reside
cannot be used for I/O when a network filesystem is involved. I think
it's a matter of time when regular filesystem start using the same
method of pining and doing I/O instead of using the filecache on fast
memory mediums.

Regards

-- Pantelis
