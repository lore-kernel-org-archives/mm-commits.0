Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316C1366
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746813040; cv=none; b=A/XFIGCUtwM8a6dZpvi5r9WLJhma5OkxEspw+tjQ/Vq2eglzPULlAspaHiR05Dp8hXSeEi33G221q2KDIPgsP3G2OvuZLPnTygOkyDaVOE2lojWPW2gQG9vIrEtem46ti5yC6VJkt/6/g6yewb5UrtPIgQUxSk1idBypNDJKqNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746813040; c=relaxed/simple;
	bh=pG/YFrrwH4uLEsV9bejvAzDcriv7LB77ZInd8q07z24=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=F9TVeMQIMdHc9JEafO3M7HIasL72UksOkFCI6/15zbHcJeHXXqQizElFhBNas++4vngCOSB9tNK/6qy2YujCvT5xLIbDA/ukeeWRjPl5AGZj9xPY+Azob5JO5ja7qvjRAEHJsTWe5P0KoI9UJuXOrw69TJIGnjkTTdA6CT//yic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I6TNqcUh; arc=none smtp.client-ip=211.189.100.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I6TNqcUh"
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20250509175029usoutp01e4372a592a528b82188612959eccdfda~97TIO3KFW0053900539usoutp010;
	Fri,  9 May 2025 17:50:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20250509175029usoutp01e4372a592a528b82188612959eccdfda~97TIO3KFW0053900539usoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746813029;
	bh=pG/YFrrwH4uLEsV9bejvAzDcriv7LB77ZInd8q07z24=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=I6TNqcUhfH20C001f0AtlUp5q+QGAmPLBQyfWDJ+h/HZesNCRvPlyyTLEj/z37DwL
	 9P5N2QxmhdkoAgH//FZLM7D2uqiUhzax9WfSpLIWgDuFnTAKBFsEgoWHpEhtTXmfcJ
	 e2pd/o8gpjdGLnlozQwHAeqHgK522vfLjVygfCK0=
Received: from ussmtxp2.samsung.com (u137.gpu85.samsung.co.kr
	[203.254.195.137]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250509175029uscas1p16801729ed2e28c113ddb558ef6e29672~97TH86Z4c2582025820uscas1p1a;
	Fri,  9 May 2025 17:50:29 +0000 (GMT)
Received: from ATXPVPPTAGT03.sarc.samsung.com (unknown [105.148.161.7]) by
	ussmtxp2.samsung.com (KnoxPortal) with ESMTP id
	20250509175029ussmtxp25db80d3086eb8188d5cc17385fcf09d7~97THzbrtG0880408804ussmtxp2o;
	Fri,  9 May 2025 17:50:29 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT03.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT03.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	549Ej2c8029752; Fri, 9 May 2025 12:50:28 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT03.sarc.samsung.com (PPS) with ESMTP id 46df5wcrgv-1; Fri, 09 May
	2025 12:50:28 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Fri, 9 May 2025 12:50:26 -0500
Date: Fri, 9 May 2025 20:50:22 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: John Hubbard <jhubbard@nvidia.com>, David Hildenbrand
	<david@redhat.com>, Peter Xu <peterx@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <c.briere@samsung.com>,
	<artem.k@samsung.com>, David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250509205022.26357579@sarc.samsung.com>
In-Reply-To: <20250509173314.GD138689@ziepe.ca>
Organization: SARC
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: au1ppexchange02.sarc.samsung.com (105.148.32.82) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: 2dyNdXObtghKCQaCFZLy5FGbVgz5RcNs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDE3NyBTYWx0ZWRfX/CWyEKpNCOTt
	6pOTHUYASm5eTaH2A24rHtxfn7+wvtBPnvcy1M9L8y8K2n4ak1ZpkJi31FdijrUS1jn3ppS3YOV
	uE8vwbko9ouKVuGQM2oA51IXvlSULvPI9gtX3dFmealZ6+0Qh6vwn9m/VdQiWlzjQ4RcaVo/Vjg
	mNRGsUOStWZ3qHFba17DIwcbtnXcN6n6qFy3FZOWV91tCod6VMq5VB7c6ShZm3IyRtop/CWvSJZ
	EodP9mzFYobV1UP87mh16Ks5t03xyCQLQgzTH1DRlSkYeRL40ArnbtYoyle9xdKPvyPckxaXrB4
	0LMW90aJVvqEQUpYyJulho1RU6lYyEz7kW1Zl9v5E5HPWiv4jXUpohHgVw6kQa0bEurPP6QLszA
	RhM4TsRK
X-Proofpoint-ORIG-GUID: 2dyNdXObtghKCQaCFZLy5FGbVgz5RcNs
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-09_06,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
	lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0
	mlxlogscore=975 adultscore=0 suspectscore=0 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505090177
X-CMS-MailID: 20250509175029uscas1p16801729ed2e28c113ddb558ef6e29672
X-CMS-RootMailID: 20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775
References: <20250508211136.7a0a3865@sarc.samsung.com>
	<aBz8QuzT7YkPqrrF@x1.local>
	<8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
	<aB0BI-inU839lcIq@x1.local>
	<5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
	<20250508191920.GC138689@ziepe.ca>
	<CGME20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775@uscas1p1.samsung.com>
	<5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
	<20250509193042.5a8af82e@sarc.samsung.com>
	<b7c796e9-81a9-4f1e-ba84-5e9af061ee1e@nvidia.com>
	<20250509173314.GD138689@ziepe.ca>

On Fri, 9 May 2025 14:33:14 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, May 09, 2025 at 10:=E2=80=8A11:=E2=80=8A01AM -0700, John Hubbard =
wrote: > On
> 5/9/25 9:=E2=80=8A30 AM, Pantelis Antoniou wrote: > > On Thu, 8 May 2025 =
21:
> 34:=E2=80=8A28 +0200 > > David Hildenbrand <david@=E2=80=8Aredhat.=E2=80=
=8Acom> wrote: > ..=E2=80=8A.
> > > So what's=20
> On Fri, May 09, 2025 at 10:11:01AM -0700, John Hubbard wrote:
> > On 5/9/25 9:30 AM, Pantelis Antoniou wrote:
> > > On Thu, 8 May 2025 21:34:28 +0200
> > > David Hildenbrand <david@redhat.com> wrote:
> > ...
> > > So what's the plan now?
> > >=20
> > > DRM seems to be the first place to be fixed, however am I wrong in
> > > thinking that most of the uses of remap_pfn_range() are wrong in
> > > the context of system page backed memory?
> > >=20
> > > Should we start with an implementation of something like
> > > remap_range() which does not set PFNMAP bit. Its use is wrong in
> > > that context IMO.
> > >=20
> > > And then move to DRM proper and replace the call to
> > > remap_pfn_range() with it and see how far we go.
> > >=20
> > That sounds like the right approach to me. Because the way we get
> > into these problems is mostly due to the lack of a clear example,
> > and so providing something correct to call is the way out.
>=20
> Thing is if you want to just install struct page memory you don't need
> MIXEDMAP or a special call, just insert the pages in the normal way.
>=20
> The issue here seems to be that the DRM caller wants to mix and match
> struct page and non-struct page memory, so I think you want an
> entirely different API for managing effectively a scatter of two
> different memory types and computing what the proper VMA flags should
> be based on what was given.
>=20
> OR DRM is actually using remap_pfn specifical because it does not want
> 3rd parties taking the page refcount because that destroys its
> lifetime model..
>=20

To be frank our driver does not explicitly call remap_pfn_range(), I
just saw that there is use of it in other drivers and is found in many
tutorials for writing drivers that share memory with user-space.

However our driver is dependent on the drm_gem_mmap_obj() method where
all paths end up setting the PFNMAP bit, and the remap_pfn_range() method
is the easier way we could reproduce the bug in a simplified test-case.

A quick grep for vm_iomap_memory and remap_pfn_range in drivers/

$ git grep -e 'vm_iomap_memory\|remap_pfn_range' drivers/ | wc -l=20
92

I have no idea how many of those are operating on system memory pages.

From my understanding DRM takes full control of the lifecycle of the
buffer objects in question, so I don't think that the page refcount is
applicable here.

Turning that bit off could expose the pages to the swapper which I guess
would be pretty bad (maybe, not my particular area of expertise).

Do we have any DRM maintainers available to chime in about the page
lifecycle?

> Jason
>=20

Regards

-- Pantelis
