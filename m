Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A78C433C1
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 09:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A93961973
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 09:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCVJGe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:06:34 -0400
Received: from mail-eopbgr1410087.outbound.protection.outlook.com ([40.107.141.87]:52928
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229897AbhCVJGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 22 Mar 2021 05:06:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTQG/Bl72QSBulsLY3bDCHNTDzcmL7BIi4LLcEUjeM2jAn6+9QxjDneuEJsv/L6/sU4kpsVIuHGj1wjFsYsaOngqGej9zFqj7GmvRroNRZOTmDYEQv1v3vAMTZY1zWMNaQP2Zgpy5USuIz5cWdqIAWbaapPgXWOxswXoCC4qXgZ80TAFpsBBIw7nng7B+/1FiuerAF6ApkgwWu16qbp8/P1dI+4HOiGLHiu2LXfpJ8wJYFdTleOvd8xHsR+DkbA8nVKaEQUDlR7EQSQ7xTd3lg89i0vkdAF0N/vu1gmL2HFNQEuXh6iqbkZUP8zfStx7iy/+IGwKhsV1LLK7MaUp/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhw3Y/Br5Rv2e098xyMYsrpCGwiY2lLZfAL3bUyKt2I=;
 b=cjNb3YUAYPnKBoqbFdXWllMEOwbwGVQ+V4H5rRzp2R/iFi/DoytnvIzGdnXWlgcuWA2OVDS2dp5//c6FNhV1t9psRou5RGW3MfQ5hjWGk+p5/AgkbuGux2tzBddYI3kW/SEf6Oe6q5YDUQBa9fJyRp8sKGeC+zsGs13tIqtc/4aPRgH1oAHD/9cLCj5HSurvhNiJDmnct44KCTEyknNU6zrwvyUPsln/stIvbI8czkE8KyUZ4YpvRq3kB0kgyrFhuhi8u/7+H/Op9P0+ISDs9BA0sDt0G8rCsohbCdgmnrutsBAI973YR1+jLCndWSgj21iASQHUz0OTMktrKTOBMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhw3Y/Br5Rv2e098xyMYsrpCGwiY2lLZfAL3bUyKt2I=;
 b=R5IFJQGrHKfHyiASw8j3nU4LCxVDEGubo9MrWk5ZLsVAOQ7dLEp6lsQqn0ShYatTqKArA/q++qMBzqwhHDFytjgwGZ53yCzaPHP7VYrHRPbwdjCe6ATPh+8TQrsZLVgQzRTc1HAE5rOKosar24nVZJJ8K6FmQ2KKHtCOB5ROf1U=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TYAPR01MB4878.jpnprd01.prod.outlook.com (2603:1096:404:129::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 09:06:11 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::1552:1791:e07c:1f72]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::1552:1791:e07c:1f72%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 09:06:11 +0000
From:   =?iso-2022-jp?B?SE9SSUdVQ0hJIE5BT1lBKBskQktZOH0hIUQ+TGkbKEIp?= 
        <naoya.horiguchi@nec.com>
To:     Aili Yao <yaoaili@kingsoft.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "david@redhat.com" <david@redhat.com>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>
Subject: Re: [PATCH v4] mm/gup: check page posion status for coredump.
Thread-Topic: [PATCH v4] mm/gup: check page posion status for coredump.
Thread-Index: AQHXHs7bo1b2cw8ixEiLmhA2QPNeGaqPt5aA
Date:   Mon, 22 Mar 2021 09:06:11 +0000
Message-ID: <20210322090611.GC23380@hori.linux.bs1.fc.nec.co.jp>
References: <20210320002238.hHjZEha58%akpm@linux-foundation.org>
 <20210322115233.05e4e82a@alex-virtual-machine>
In-Reply-To: <20210322115233.05e4e82a@alex-virtual-machine>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kingsoft.com; dkim=none (message not signed)
 header.d=none;kingsoft.com; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.97.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e69d5ab1-46fe-4c79-b887-08d8ed11bd4d
x-ms-traffictypediagnostic: TYAPR01MB4878:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB4878BD669203CCF3182CB2C0E7659@TYAPR01MB4878.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qhfFX6S/TOCZzAaeg41D88UKc+ppawPGM0B+Zhgq08lYyVYqu5JPxHLsgfG397zUfBMPIQ466Tbd0Re45yK5eZPbdvVMYKugJ77UAAgtWoIuDjnv527a7gd154oKkiAuVd0UxiC8NZzvgjf2Kg33+dEVkqF2lrMLWneGIe4Us6+cAP1XssEq1mXAYL71xgbMvC6/51slUeSDFtghEi+2PR1L1DI9boHJA4Ei/aJd+3rQ112KKXeI92d+cQ+akctQQ8ghnzNR8VuiaxwcXr4/7OWPwSFpsf5wHR/z5z/cP7d1ArODXcp6wqgeSnOcwSCAgYTPWHsvJeKxcGEsrhqyym0K1mb6H/Tte+OPtFje9FgGXtrnrVzcAj/9NUUpBY+n7HgYUzFEML+UQiZ5nf+t011VT7BASKTCq5l12kGlQV1C1qAylVPLv5MxrwCeN4DpiqtirExMKEXQgwidRe371AqwA2KLyGhr2bzNFnSDBbuUhUPjLlFpH5pcOc/4XGxhbbcgIveawR1mQQm9wbRmtOyTkT0mUFhl9NLNVkmFOSRe78TErVfJ1c151UAQaWmlhBXeV9+03qRLIz4ImWWrWeO0dwOIljk/jxtAmpfoH7FTFIn3TPmO31+asApeZ9cwi79KPb2Hk7a8eEP/OhzWs6Uk1i7+cAaHbKcUSPRecG4M+k9XNefN6TDmhaudzAwAqlvCx0J2tcARRJmPZ0tm0U5i9YxVLYz4HQ1dh4olhns=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(5660300002)(66476007)(1076003)(316002)(66946007)(85182001)(71200400001)(8936002)(478600001)(38100700001)(76116006)(4326008)(8676002)(66556008)(86362001)(64756008)(66446008)(6486002)(6916009)(186003)(2906002)(9686003)(6506007)(26005)(33656002)(966005)(54906003)(6512007)(55236004)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?RVcwcW1jQllRUGlSSllwMzBEVEd1dE50Z0VQeHVBamxHa3lLckduVEFx?=
 =?iso-2022-jp?B?VE0xemlXdDFscEtsTlFxT0p5bHBVajhQM3h6RkxWSFpCS1JVU2M0QmZy?=
 =?iso-2022-jp?B?c1ZrSFpWRXJNd2I4NDlJOFZPTWQ4UVlTbnFUMU51bnlhQXFvL3dWSXp0?=
 =?iso-2022-jp?B?RWpZeHo3a2o1YzZYbTE5eFhmMkdXeGZ2eUMzUWxtOFF3QXZjQmpsRDNL?=
 =?iso-2022-jp?B?RklpNitlVEVMcEVxTzhBbHF2L1M1c1lhM3dHSkxGUU1WSTYwSmNaRGw3?=
 =?iso-2022-jp?B?OFE5NjdXUDhBOTRlV1hQa0pSdzE2SVc5TmZ3bUhBRGdta2JXM01IZkwz?=
 =?iso-2022-jp?B?YksvWW9UOWpKVG5Pb1dobkdzT1lXTTRMekdqVXlTOXppZlF6VitZTExW?=
 =?iso-2022-jp?B?TzNNaU5ZNHJuTlJOY0lVN2lCdDlaK3Ixa2pKN0o5WUVoWGhvVWFuakRo?=
 =?iso-2022-jp?B?NXNHQXd0MXY5d2FabTJLZnpHOFllWm5OaHZ1YjZSTHI2a0lUNDQ1MjQ4?=
 =?iso-2022-jp?B?SDF2MmZSdmdnVUFvZkxEUm5COWgwS3ZxWWMvV0lzRjlic2RQanBoUWcy?=
 =?iso-2022-jp?B?dmZEbzcyZ0FPMGxnV3l6N08rOEg4c2h6WGNQbVQ1NE1tZEZ5R2RoakxI?=
 =?iso-2022-jp?B?ajVERE5sS3poSzJScGcxUDBmWFpTRk0weXFVWjgzc2tuRXMyVWxVbTE3?=
 =?iso-2022-jp?B?NXkzWnAzd2poRUNUS0J5WlpmQzh1dHZzQTBsQ25wUkpPRFB3Z0ZoZWZi?=
 =?iso-2022-jp?B?cEFuWi9VY3VDNTdYQ0pDYXpaZ0g1NjY1NHd6SDJUeGpIOGZVMHhwa1Ev?=
 =?iso-2022-jp?B?NHBaQklKVFpCMVFYMTZheWU4a1grYVl1NlBiREFEaGVWZ2lJdmgzRFA1?=
 =?iso-2022-jp?B?cjBLeDZhcDRVeU5obUw5QXdoeVQ2Y0o1RVhPVGkrN0crblVVakVPaFU0?=
 =?iso-2022-jp?B?S1B2N3I4aXc4MFYyWDQvcVE4bFM3N0Rmd1pHNSsvU1pJYWJqVzZ4LzJp?=
 =?iso-2022-jp?B?N1AxazhxcUVoaWY5bis2ZXJuOWFyS3NvVThacS8vS0ZCU0hOdE9rTnJt?=
 =?iso-2022-jp?B?YkgyczZ0NXAxMi9qSXpGSi9ta3JJcXBNVmJDQ2tGd1ZaWmsvYjJ0N2dj?=
 =?iso-2022-jp?B?MXEzS25Ic2ZEQlFIVUtNL25GK3gyWXN2MldNT24wMFlndXVCZFkvb0RL?=
 =?iso-2022-jp?B?by9hRCtQSjFndlpuNkRNYjR0bkh5NGxVQnM5aUVNdklzNE1ablJ1bjVU?=
 =?iso-2022-jp?B?M2hSQ2JvcmJRQUp0K3M3WXd5aGpSWlFsTUsxUVJHck1HZkI5c1BuTXVn?=
 =?iso-2022-jp?B?NEdEU0hEbnVnT01sYUxsUDE5UVVKOThtWlBHRlNKWkRmUzF4T1JlZWhZ?=
 =?iso-2022-jp?B?Ymw5UVNtcDFtWExEV0FqaEIvN3JKRU9iNk5MK2VpS015MUY4MjdlNE1l?=
 =?iso-2022-jp?B?T0h4eGJDODQwUVNWWTFZQ0hlbTRYU2ZINm5pRE5VUUdqeXJKZUxjd3BG?=
 =?iso-2022-jp?B?ZFNuRkpHbjhhK3JFRlpsc2duTjNQYU1WR3VBRTVOQ1lJZ2oyOGZNSzZy?=
 =?iso-2022-jp?B?ZktjTmlGNllXMStZMUlpRFhBU0ZWQzBaUitQeVJ4dTRKNjR3L3pUL3Bh?=
 =?iso-2022-jp?B?em05YVBVU1RGWG8zRkRUdGlseCs3ZDhkRy9PaG1FaUtkdCs2WTU5eU5G?=
 =?iso-2022-jp?B?RWpwSUd2dFI0eG41Zkx0c2xWVVFiU2tFTTNGeE5icFBQRXdPbzB4M0Yz?=
 =?iso-2022-jp?B?MDBteUthV3JDaVE1eDREK05sL0ZIMUhYVUEyMnBJaVRGbEE5MnM5RTY4?=
 =?iso-2022-jp?B?YUdhejZ5WFh2UW84NU5ETDdSMS9JR0U2N0JLNkFaNHJzdm9YSlVLRnY0?=
 =?iso-2022-jp?B?WHY3WUV5cktGdVdoNVFIMUJKMitmcVlRTTlHRk9HOTVEVnk2WjBTMEVq?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <7316C3A46A3578458B18A31CE18BDC60@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e69d5ab1-46fe-4c79-b887-08d8ed11bd4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 09:06:11.8799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kj99C3NIgaV7kzMGA9Y9IHy/Prqn1sFYKVAD7x1LySE6FKE2wk3M96BPcXdVmRsH8ZB5sijSlIlqGabduQtVCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4878
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Mar 22, 2021 at 11:52:33AM +0800, Aili Yao wrote:
> Hi Andrew:
>=20
> Thanks for mergeing v3 patch into mm, but there is still a modification s=
uggested by
> Matthew Wilcox needing to finish. I am not sure how does the right proces=
s works. I post patch v4
> here, if anythong wrong, please point out.
>=20
> Thanks!
>=20
>=20
> When we do coredump for user process signal, this may be an SIGBUS signal
> with BUS_MCEERR_AR or BUS_MCEERR_AO code, which means this signal is
> resulted from ECC memory fail like SRAR or SRAO, we expect the memory
> recovery work is finished correctly, then the get_dump_page() will not
> return the error page as its process pte is set invalid by
> memory_failure().
>=20
> But memory_failure() may fail, and the process's related pte may not be
> correctly set invalid, for current code, we will return the poison page,
> get it dumped, and then lead to system panic as its in kernel code.
>=20
> So check the poison status in get_dump_page(), and if TRUE, return NULL.
>=20
> There maybe other scenario that is also better to check the posion status
> and not to panic, so make a wrapper for this check, Thanks to David's
> suggestion(<david@redhat.com>).
>=20
> Link: https://lkml.kernel.org/r/20210319104437.6f30e80d@alex-virtual-mach=
ine
> Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you.
This is a simple and clear fix, so I think it's worth ccing to -stable.

> ---
>  mm/gup.c      |  4 ++++
>  mm/internal.h | 20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>=20
> diff --git a/mm/gup.c b/mm/gup.c
> index e4c224c..dcabe96 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1536,6 +1536,10 @@ struct page *get_dump_page(unsigned long addr)
>  				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
>  	if (locked)
>  		mmap_read_unlock(mm);
> +
> +	if (ret =3D=3D 1 && is_page_poisoned(page))
> +		return NULL;
> +
>  	return (ret =3D=3D 1) ? page : NULL;
>  }
>  #endif /* CONFIG_ELF_CORE */
> diff --git a/mm/internal.h b/mm/internal.h
> index 25d2b2439..dcd2051 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -97,6 +97,26 @@ static inline void set_page_refcounted(struct page *pa=
ge)
>  	set_page_count(page, 1);
>  }
> =20
> +/*
> + * When kernel touch the user page, the user page may be have been marke=
d
> + * poison but still mapped in user space, if without this page, the kern=
el
> + * can guarantee the data integrity and operation success, the kernel is
> + * better to check the posion status and avoid touching it, be good not =
to
> + * panic, coredump for process fatal signal is a sample case matching th=
is
> + * scenario. Or if kernel can't guarantee the data integrity, it's bette=
r
> + * not to call this function, let kernel touch the poison page and get t=
o
> + * panic.
> + */
> +static inline bool is_page_poisoned(struct page *page)

The word "poison" is abused even in mm subsystem, so please use "hwpoison"
to be distinct.  And please send a patch to linux-mm for review instead of
replying to this thread.

Thanks,
Naoya Horiguchi

> +{
> +	if (PageHWPoison(page))
> +		return true;
> +	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
> +		return true;
> +
> +	return false;
> +}
> +
>  extern unsigned long highest_memmap_pfn;
> =20
>  /*
> --=20
> 1.8.3.1
> =
