Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E7239E71
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808260; cv=none; b=A/3dYeD698NaahO+wrpS2A7bhen4SYZ4DUrmg8hfLBAofUPO5i+jkh/4qKW0isBXDwoL+eg1QpVc0xDjfUmidmB9ikTgdqBYvcmVxs1oQ/V1Ds8KvZxUUB8/XBumW6mSA4njcfPOrBr85lKU0hL31og5XP/UMpr/ISNANoj9ZNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808260; c=relaxed/simple;
	bh=SpDUDTGfXhHhNvkIwyPOPBz5n/k31gL/CVJUCaVSaS8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GIvqyOjR7MD8N0mp2FnRy/JlpGgf6/kGjcNj+OXFzKn5ahPUiqbfztcZuvF5GSjehuGy3qti9RDZ51sriLWfgY9s+XNpILiS5EJFn/wSCoXSdme6KZGNBA1MozlDhbD774F9ZANSPeHmFvL4fCtajnz+juVaooGOwobJKRA4G3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com; spf=pass smtp.mailfrom=partner.samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=do4XuglU; arc=none smtp.client-ip=211.189.100.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=partner.samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="do4XuglU"
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20250509163050usoutp028805d8717b363a615473af79bbe64d15~96Nk4vhok1308913089usoutp02E;
	Fri,  9 May 2025 16:30:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20250509163050usoutp028805d8717b363a615473af79bbe64d15~96Nk4vhok1308913089usoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746808250;
	bh=axbJtuAEqciQrP7N5PHNA1Kuif35h8vM1ln24s24Ml0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=do4XuglUbL7uECRA9Zcphov1U1YaR6GkcaqA2Kk4dTz4xBPxDscsQh2+j0G8yswr9
	 6pHkocKLTXVAwlww9mii6IQC+o0CTmIvj/jbua8CrTPjRCfp4W2J3sn60FwAfcnefz
	 cWKL5/ftfORansv+WC5dC9leRHDk4e9LST73oj0k=
Received: from ussmtxp2.samsung.com (u137.gpu85.samsung.co.kr
	[203.254.195.137]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250509163049uscas1p15e867e0de9047ef830d3b83df509d034~96Nkifdnq0109501095uscas1p10;
	Fri,  9 May 2025 16:30:49 +0000 (GMT)
Received: from ATXPVPPTAGT04.sarc.samsung.com (unknown [105.148.161.8]) by
	ussmtxp2.samsung.com (KnoxPortal) with ESMTP id
	20250509163049ussmtxp25ba0f7546cd56ba747ce6dd05b74ec9c~96NkZOChe0417704177ussmtxp2I;
	Fri,  9 May 2025 16:30:49 +0000 (GMT)
Received: from pps.filterd (ATXPVPPTAGT04.sarc.samsung.com [127.0.0.1]) by
	ATXPVPPTAGT04.sarc.samsung.com (8.18.1.2/8.18.1.2) with ESMTP id
	549DlrGS061560; Fri, 9 May 2025 11:30:49 -0500
Received: from webmail.sarc.samsung.com ([172.30.39.9]) by
	ATXPVPPTAGT04.sarc.samsung.com (PPS) with ESMTP id 46df5w4q1p-1; Fri, 09 May
	2025 11:30:48 -0500
Received: from sarc.samsung.com (105.148.145.5) by
	au1ppexchange01.sarc.samsung.com (105.148.32.81) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.1544.4; Fri, 9 May 2025 11:30:46 -0500
Date: Fri, 9 May 2025 19:30:42 +0300
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
To: David Hildenbrand <david@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wade.farnsworth@siemens.com>, <jhubbard@nvidia.com>,
	<c.briere@samsung.com>, <artem.k@samsung.com>, David Howells
	<dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250509193042.5a8af82e@sarc.samsung.com>
In-Reply-To: <5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
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
X-ClientProxiedBy: au1ppexchange02.sarc.samsung.com (105.148.32.82) To
	au1ppexchange01.sarc.samsung.com (105.148.32.81)
X-CFilter-Loop: Reflected
X-Proofpoint-GUID: fwq-GZ1eFHLc26DEhtudnzmLp9SGTi42
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDE2MyBTYWx0ZWRfX5x/PV3YCc038
	/INGVb8Zs3t2R3UFSmZYjEPWhsKBIBaCXD7VA6e7qmm51OsDCvrXYxgNDbtfyl6lXR9z0D/CNGA
	zcrzGXgoanoAFQMD2hcPtyx+MGlmulu3t+zX/riz14fQP8LTQ+E2vAUE0WIEZckDYnyrbpKLlHJ
	5D4AN5/TIsw9JK4MnBQWY1ABs7rBlbkdyNcjxr0VX0rKnS+L1RaH0PBvngcXHWrOV3Yjk8xkIDg
	yPL0Zji7fRF7bwEa75IGfvKDTSt3sEm81JLc2LfnLpwGCrEBFdzORWYDiglRBncE0xpuFeqz6Eq
	nDSPR0t8COrDTwSXlIXHjiFXssEhUmI8Yhot6zWUzmitPKZ0yB9mEntWFdOcghRTa92bCtaDHnX
	nfkmzib3
X-Proofpoint-ORIG-GUID: fwq-GZ1eFHLc26DEhtudnzmLp9SGTi42
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
	definitions=2025-05-09_06,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam
	score=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
	priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
	lowpriorityscore=0 phishscore=0 clxscore=1015 classifier=spam adjust=0
	reason=mlx scancount=1 engine=8.12.0-2504070000 definitions=main-2505090163
X-CMS-MailID: 20250509163049uscas1p15e867e0de9047ef830d3b83df509d034
X-CMS-RootMailID: 20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775
References: <20250508182718.40f16121@sarc.samsung.com>
	<e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
	<20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
	<1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
	<20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
	<8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
	<aB0BI-inU839lcIq@x1.local>
	<5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
	<20250508191920.GC138689@ziepe.ca>
	<CGME20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775@uscas1p1.samsung.com>
	<5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>

On Thu, 8 May 2025 21:34:28 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 08.=E2=80=8A05.=E2=80=8A25 21:=E2=80=8A19, Jason Gunthorpe wrote: > On=
 Thu, May 08, 2025
> at 09:=E2=80=8A14:=E2=80=8A38PM +0200, David Hildenbrand wrote: >> On 08.=
=E2=80=8A05.=E2=80=8A25 21:
> 08, Peter Xu wrote: >>> On Thu, May 08, 2025 at 09:=E2=80=8A04:=E2=80=8A1=
1PM +0200,
> On 08.05.25 21:19, Jason Gunthorpe wrote:
> > On Thu, May 08, 2025 at 09:14:38PM +0200, David Hildenbrand wrote:
> >> On 08.05.25 21:08, Peter Xu wrote:
> >>> On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
> >>>> It's doing the same wrong thing at a different place.
> >>>
> >>> As I mentioned, I believe KVM has this wrong thing working so
> >>> far..  and it doesn't block us from going right ultimately.  It's
> >>> a matter of time.
> >>
> >> Yes, KVM has it wrong and vfio probably as well. And they are
> >> usually not dealing with actual kernel allocations, but rather
> >> with MMIO ranges.
> >=20
> > vfio also doesn't take references on the things it pulls out of the
> > VMA. The vfio bug is different, it lets you take a pte special
> > phys_addr_t and reference it through the IOMMU without any
> > refcounting. So when the VMA is destroyed and the page free'd by the
> > GPU driver we just UAF it from VFIO through the iommu page
> > table. Woops.
>=20
> Right. What is_invalid_reserved_pfn() does is check that if it has a=20
> "struct page", that that one must be marked PG_reserved.
>=20
> That PG_reserved check is a nasty check for MMIO pages or memory
> holes part of a present memory section.
>=20
> So at least it will reject anything that is just an ordinary kernel=20
> allocation (!reserved).
>=20

So what's the plan now?

DRM seems to be the first place to be fixed, however am I wrong in
thinking that most of the uses of remap_pfn_range() are wrong in the
context of system page backed memory?

Should we start with an implementation of something like remap_range()
which does not set PFNMAP bit. Its use is wrong in that context IMO.

And then move to DRM proper and replace the call to remap_pfn_range()
with it and see how far we go.

What do you think?

Regards

-- Pantelis

