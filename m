Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF48B278169
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746717463; cv=none; b=ZNNH+NZYyis7VwchGkp9K69aGru/KW+M7wuIiazgliO5+FaCl1xR0z0LhwzbIFEnuUEsecWxEN+NkjbiAHvGhziHB+nh9VMsL2+2IJpW4QGCWPZV9ErmAV9z72wOYf+Yf/N4vRncR3r54ktxcZKtPXAzGycxt7SauM0fsLYKov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746717463; c=relaxed/simple;
	bh=jkCXl6w3jhR+kRI3ufEAtrSjenHUl6K6+BeKIpRusU4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=D8FITy1WJ7v7XHHB7yWzklTINzs16b9fnC2WiMm7TeHCV4kynuwuGN1WYMIdSjn53TP5xSKUvnN9E/HmLryo2qo57Pv+rR7mRiqbnoRDIf1InFVmstcrTfd3Rqaiud8Lq5yWyxQ/mJMxaW2SDEdHSxq4NchXF27Xqs23U4YZmho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M31dLuH+; arc=none smtp.client-ip=211.189.100.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M31dLuH+"
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20250508151738usoutp01a197fd2ffdddd54f7fd1728de93419df~9lkYfAPoX1883018830usoutp01g;
	Thu,  8 May 2025 15:17:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20250508151738usoutp01a197fd2ffdddd54f7fd1728de93419df~9lkYfAPoX1883018830usoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746717458;
	bh=JvubT4RqX8Y7cI5b3X3BVWzQ3ScjNQYUTpeXYSaF6Wk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=M31dLuH+mVGfUcL5jXOIfcGOupUoSqTha1ZEFBbyBnKjBkW7x0Zz5A5Bp6QFH4NYG
	 G0TyFyVdFwY81kg34Y++REjI8kw4zgdUE3JSJJnCitcFUpmfvqsRLE9Iai/FMVBTf5
	 HS7FVBuL7qLNoNvJ+GZZ1Xqj0DqkoS0O3y+pimvs=
Received: from ussmtxp1.samsung.com (u136.gpu85.samsung.co.kr
	[203.254.195.136]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250508151737uscas1p12e166640f4be12e552904fe9a0a75f20~9lkYECrcA3152031520uscas1p1K;
	Thu,  8 May 2025 15:17:37 +0000 (GMT)
Received: from ATXPVPPTAGT03.sarc.samsung.com (unknown [105.148.161.7]) by
	ussmtxp1.samsung.com (KnoxPortal) with ESMTP id
	20250508151737ussmtxp18bee44537d72c0c30c09b8f9d2f24a20~9lkX1ZEzh2613826138ussmtxp1I;
	Thu,  8 May 2025 15:17:37 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT03.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT03.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	548Chh0j030080; Thu, 8 May 2025 10:17:37 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT03.sarc.samsung.com (PPS) with ESMTP id 46df5wbv20-1; Thu, 08 May
	2025 10:17:36 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Thu, 8 May 2025 10:17:34 -0500
Date: Thu, 8 May 2025 18:17:30 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: Peter Xu <peterx@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <jhubbard@nvidia.com>, <jgg@ziepe.ca>,
	<david@redhat.com>, <c.briere@samsung.com>, <artem.k@samsung.com>, David
	Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508181730.4960436c@sarc.samsung.com>
In-Reply-To: <aBzI3sl6r3HtAWP4@x1.local>
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
X-Proofpoint-GUID: 7tYmel41DTUGcs0syU9oArQksQcEoVha
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDEzMSBTYWx0ZWRfXwRGn6sFy3Trt
	LySUd5DOH0259KLgc8WdYtla3m5GZUccjctYScssgDmPfWImeSWf6XvDYaNa6s8NAIvBL70ClX8
	n70c66/Q7EEa6/zZP7MflHijc/BKEOfSCC4+NR2ZzheaqlrsMwLvrtworNMnRF8aDNvVQGPWsPO
	5iozb1No/VUs1T/5AKVpjBaVFPzGAEVw12nkH0f5CMdJODazGgaw2yjmdN7y71PjQeDUQxAs7Ae
	sN8Ixcbgv2a5Amnan9F+q2C02TUHhVG5O9rrZ7rg2CCQnG2Kb9HosvBJv8xg7SQxeH+HUxSz4hR
	B3wq2AvFvqQF0HuSjha+vPc4WNSd8zz/KWbzpcnRuUOrjGoMhXe2mU55AFDppywPbcHl7bkcbfl
	x8VUsdsO
X-Proofpoint-ORIG-GUID: 7tYmel41DTUGcs0syU9oArQksQcEoVha
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-08_05,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
	lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0
	mlxlogscore=999 adultscore=0 suspectscore=0 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505080131
X-CMS-MailID: 20250508151737uscas1p12e166640f4be12e552904fe9a0a75f20
X-CMS-RootMailID: 20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
	<CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
	<aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
	<aBzI3sl6r3HtAWP4@x1.local>

On Thu, 8 May 2025 11:08:14 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Thu, May 08, 2025 at 05:=E2=80=8A36:=E2=80=8A12PM +0300, Pantelis Anto=
niou wrote:
> > On Thu, 8 May 2025 10:=E2=80=8A16:=E2=80=8A31 -0400 > Peter Xu <peterx@=
=E2=80=8Aredhat.
> > com> wrote: > > Hi Peter, Hi, Pantelis, [.=E2=80=8A.=E2=80=8A.=E2=80=8A=
] > > > @@ -1271,8
> > com> +1287,6 @@ static int ZjQcmQRYFpfptBannerStart
> On Thu, May 08, 2025 at 05:36:12PM +0300, Pantelis Antoniou wrote:
> > On Thu, 8 May 2025 10:16:31 -0400
> > Peter Xu <peterx@redhat.com> wrote:
> >=20
> > Hi Peter,
>=20
> Hi, Pantelis,
>=20
> [...]
>=20
> > > > @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
> > > >  	int foreign =3D (gup_flags & FOLL_REMOTE);
> > > >  	bool vma_anon =3D vma_is_anonymous(vma);
> > > > =20
> > > > -	if (vm_flags & (VM_IO | VM_PFNMAP))
> > > > -		return -EFAULT;
> > >=20
> > > Is there's any justification that this won't break some existing
> > > GUP users that may rely on properly failing at pfnmaps?
> > >=20
> > > IIUC netfs isn't the first one that wants to GUP on top of
> > > pfnmaps, KVM does it for years and so far it was processed in a
> > > standalone path:
> > >=20
> > > hva_to_pfn:
> > > 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> > > 		r =3D hva_to_pfn_remapped(vma, kfp, &pfn);
> > >=20
> > > That started with supporting real pfnmaps (with no page struct),
> > > but pfnmap with page structs can also happen afaict, and kvm
> > > processes that too by checking page=3D=3DNULL ultimately, e.g. in
> > > kvm_release_faultin_page().
> > >=20
> >=20
> > I see. The problem is that we're not the owners of the code in
> > netfslib, and it is considerably more intrusive to fix things there.
> >=20
> > This is a hotfix for a userspace regression. I sort of agree that
> > having different handling for these areas in netfslib would be
> > ideal.
>=20
> Do you mean this used to work in older kernels?  Some more info on the
> regression would be more than welcomed if so..  If it fixes a kernel
> regression, we may want a Fixes for whatever patch at last.
>=20

Yes, it used to work in older kernels, before filesystems like 9p
switched to using the accessors. The problem is that there is not
a single patch that I can point as the culprit.

It took a long time to figure out but the timeline was:

1. Before any netfslib and 9pfs changes, I/O from remap_pfn_page ranges
works.
2. netfslib accessors are merged in mainline. Userspace still works.
3. 9pfs picks up netfslib accessors, things break.

I doubt any kernel CI would have a test-case for it, because it is
quite esoteric.

We do have a relatively simple buildroot patch that we can share, that
exhibits the problem, and that contains both a kernel, a kernel module
and a user space program that performs the I/O.

> Or do you mean it's a regression caused by userspace change?
>

No userspace changes.

> Thanks,
>=20

Regards

-- Pantelis
