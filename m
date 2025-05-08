Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F142868A5
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726444; cv=none; b=KCYVZj2+tV9SS1aAcQfOmoyJEv9DSLmFSdAtb2Jka2pHknwv2PzeDZciHmd7jJTlu0BkR2e8BP7Sv20sDObhB/karSpHhopeWn0Z8+Wdk+kC0EyPQKQ7IIezTnje8TJ2uSxj/2//IQTTg6D9Cx52V/eZKnVPO3XSCCnKMh2oXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726444; c=relaxed/simple;
	bh=gMx2uEFuGX0eLAz35mB29lf/lSoysVro43DxqGdnpog=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bJgaWRprkdwBzMDe8SfeGryOrjq+8UzIpnXKhXLcDqaWg5mObIcP0bL01rZda2Erfp7+GRE3FDaoH1jYuTTVzpvmVJVyzmU5zXYeen4X5RL1yN+FM1CoWX2dhcJQXkqfK4Zdm9H6ycc92T0htakdFmHj4BoXDLK1W3jkZD/CVPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=muUYYxaM; arc=none smtp.client-ip=211.189.100.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="muUYYxaM"
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20250508174719usoutp01e8618d8105e10424831d2a2c6fa60e46~9nnEyvsB42164321643usoutp01U;
	Thu,  8 May 2025 17:47:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20250508174719usoutp01e8618d8105e10424831d2a2c6fa60e46~9nnEyvsB42164321643usoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746726439;
	bh=gMx2uEFuGX0eLAz35mB29lf/lSoysVro43DxqGdnpog=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=muUYYxaMDxNZE7TjXHugeK6u1A3bBavjeJ8l6WnGCp2f27zCMeWIo3SP90t6DzVzO
	 H/pzzA0q4jKkxiJ2+HcAhgg1oxvhP37nEblQ2dv/48psgr0GcXZcsLyQuzP+tZNzce
	 1wxAkkf1kwiWFPKyX7LJx0k8H/KIBH+W4hk9i6ZU=
Received: from ussmtxp2.samsung.com (u137.gpu85.samsung.co.kr
	[203.254.195.137]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250508174719uscas1p26c41c1b0c55d5e1a14e1f3cb8980f6ff~9nnEVuL6e2310223102uscas1p2W;
	Thu,  8 May 2025 17:47:19 +0000 (GMT)
Received: from ATXPVPPTAGT04.sarc.samsung.com (unknown [105.148.161.8]) by
	ussmtxp2.samsung.com (KnoxPortal) with ESMTP id
	20250508174718ussmtxp262a247d116314278ef689c16ad74867b~9nnELFy3J1198811988ussmtxp2I;
	Thu,  8 May 2025 17:47:18 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT04.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT04.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548HUB2n009921; Thu, 8 May 2025 12:47:18 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT04.sarc.samsung.com (PPS) with ESMTP id 46df5w3y4x-1; Thu, 08 May
	2025 12:47:18 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 12:47:15 -0500
Date: Thu, 8 May 2025 20:47:11 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <jhubbard@nvidia.com>,
	<c.briere@samsung.com>, <artem.k@samsung.com>, David Howells
	<dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508204711.6cf9f6e3@sarc.samsung.com>
In-Reply-To: <20250508173535.GA8129@ziepe.ca>
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
X-Proofpoint-GUID: b_1W6mhOl3QQDw-Xoov9FYAhWt1YzIlq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDE1NiBTYWx0ZWRfX90pBhIZR8F7U
	ZeUMUvloK4dDWFDS6/Lwuk5xMdNBGXE02Eojkz/226bEeLrUZ7nG7RXrAzHjI67tZe/uM9hWdgS
	e3gbpKglw58D5iBBQziJ3r4ad6hyYWpa1AX3yx/u1w9Xhvlqf0JAIh2HM8pRyoZQX3YJ235ytTt
	1PiZH7roj4k6oa+kzfRE9DKLT0MjMI/PfheeVLOb1S3+FPudJmqe4ZmPmKboH/rhEFSocjC7Rku
	rTxZP9QTwfdtTxOWhF/Xy8+0wQ3e2NgxvMsEH395L5m1Ha/+U7sp5/Q/bPC33FPJG2LVH1/BX8X
	7kB0Q+hm8v7S9scvlNgjbJZ1jopT3qNUoD1BMh4aGxlAPiKglvm/8kJ/aEeEzB3G3VDzXm6xx5R
	zcBDQqhi
X-Proofpoint-ORIG-GUID: b_1W6mhOl3QQDw-Xoov9FYAhWt1YzIlq
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-08_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
	priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
	lowpriorityscore=0 phishscore=0 clxscore=1015 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080156
X-CMS-MailID: 20250508174719uscas1p26c41c1b0c55d5e1a14e1f3cb8980f6ff
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
	<aBzI3sl6r3HtAWP4@x1.local>
	<cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
	<20250508182718.40f16121@sarc.samsung.com>
	<e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
	<20250508173535.GA8129@ziepe.ca>

On Thu, 8 May 2025 14:35:35 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

Hi Jason,

> On Thu, May 08, 2025 at 05:=E2=80=8A40:=E2=80=8A15PM +0200, David Hildenb=
rand wrote:
> > > I don't think there was a deliberate decision here, but there was
> > > no > > conversion to remap_pfn_range(), the code (in DRM) was
> > > always there. > > > >=20
> On Thu, May 08, 2025 at 05:40:15PM +0200, David Hildenbrand wrote:
> > > I don't think there was a deliberate decision here, but there was
> > > no conversion to remap_pfn_range(), the code (in DRM) was always
> > > there.
> > >=20
> > > The regression occurred when netfslib started using GUP for I/O
> > > and when filesystems switched to it we hit this case.
> >=20
> > Okay, so GUP and DRM always worked that way. They are essentially
> > incompatible at this point due to VM_PFNMAP.
> >=20
> > So netfslib requesting something that is impossible is the problem
> > .. or rather filesystems switching to that and not realizing the
> > problem.
> >=20
> > Hmmm
>=20
> This patch definately doesn't look very good as is.=20
>=20

No argument praising its beauty from me.
What is the right solution then?

> We *certainly* should not be even trying to touch the struct page of a
> VMA_PFNMAP *at all*. By definition that is forbidden.
>=20
> It looks to me like vm_normal_page() already supports MIXEDMAP, so
> probably the better hotfix is to have DRM use MIXEDMAP if it is
> installing PFNs that it is willing to be used as struct page.
>=20
> But who knows if DRM can do that on arches that don't have
> PTE_SPECIAL..
>=20

The question from me is why a __get_free_pages() area that is passed
to remap_pfn_range() gets the PFNMAP bit set.

Even if DRM sets the MIXEDMAP bit PFNMAP will still be set.

> Jason
>=20

Regards

-- Pantelis

