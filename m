Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE6BC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB5660EDF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhKEU76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:59:58 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:29409
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230064AbhKEU76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:59:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViLo0AyIBdpuRqDeF4zjgumzBbVREWFdxavmf1NWzbH4reAXMGIitVjGMU6FSX2Ma04PmYKkwqMauEARRdY9BxXZ6fUQIpMy3MkI2HAiK8qy5NnEI+cjCUrkhMGQh9FIiQz+LsRy2h5OLMuUSfZqQbBw14ZrRYFlroSaM1xSz2I3xtfyWnXSGJpLDCok3cmHQUwk9TplGkNiHN12jMfVXsKgb4cy0SKv8ccB0fxKpUSfP+uwlYK8HxbErSgvDhzuEfm9NkhNMKd9Z+NhvIFSpker28GAIDMhNIIQEaACfginkZOX60vKE3/cbvY2c1iP/9pRxid/BJCvoAUsvZmSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Spj2P15Ry8Ro/38HqGVHx0hZuRsLWJlWQkGBA+vZDSI=;
 b=oZkRXC9w29LcSFwWj++Jus4s2p8/+hQTA/0FFHxGzQHUfIzj/WglGu7bWvW4HGRSHgH5SS6hBjmcziwVnUsq+1SfMtFFYXhWXM1dq7q78QULXFtvb6gjudpXfD9U7jmS63eoMUiHAU05dbPrhYzxEoE7jcC6YJLbbzdDoe6JUaDAaYEGlYiQrkpo5PVKwpGOYc4OXpmcJq28M0K+RdShnjHwMjM8J73/ZBcema7jO2ITmtm2DXCGKJKgCX0QXnY64isQCB3/qj4ulfB7rsohog6IHI4qafN0B26pBwRREM36kRQd7tHB7ubb6/0NFdHhFQo6+KoGFI4c4Dr2sp4E1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Spj2P15Ry8Ro/38HqGVHx0hZuRsLWJlWQkGBA+vZDSI=;
 b=rjUfqj1JB5PKhrFOUh9IUB4QuaTMISFAeKin47xTlv+rmSK4w6l8oGZOvyh6XaMCqwQ3I270cTfGg258ETQVOj2BqSzzivcwCE3mQ5cNGbcDZdnEZmo+4cZ5qki118WkzzB9yeV/sQzC4fDKDhxGmY/LcbPDvLANIAxv8w4ENBo=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BYAPR05MB6471.namprd05.prod.outlook.com (2603:10b6:a03:ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8; Fri, 5 Nov
 2021 20:57:16 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d%9]) with mapi id 15.20.4690.008; Fri, 5 Nov 2021
 20:57:16 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Nick Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [patch 071/262] mm/memory.c: use correct VMA flags when freeing
 page-tables
Thread-Topic: [patch 071/262] mm/memory.c: use correct VMA flags when freeing
 page-tables
Thread-Index: AQHX0oUUKNR8q6iLFUSk7J8WI/f7cav1amKA
Date:   Fri, 5 Nov 2021 20:57:16 +0000
Message-ID: <2F9ABC3C-1B24-4A0B-9F4D-C1EA225F26E4@vmware.com>
References: <20211105203821.mV5HWKCGr%akpm@linux-foundation.org>
In-Reply-To: <20211105203821.mV5HWKCGr%akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3916b785-59f5-435d-f2cc-08d9a09ed981
x-ms-traffictypediagnostic: BYAPR05MB6471:
x-microsoft-antispam-prvs: <BYAPR05MB647197E4D57CE579C56E1710D08E9@BYAPR05MB6471.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DO4u2IqVkm01JWjCx6/tjQQrhmvCc09Sqwd2bTtMlwvPdsyMFYmzaLUPIJdkEJt0Lk4Iwrn05l4CIe8H7M1gHYud5uDnqSy2YX5bQXJxW+niRC47WhwaH4PB3CCh0sn+XwSfD1CyrBU2e5pJAdAkA0KlbpellwxXY6WZV4FxeaGX5n1j2dfR90ql35UIgrYCUbo4yA5f3/0nOCakZRk98iP57IeBkFck0moOLySKU9MQNnju4cmh6fTXdtyy0kwRvreoWNK0KyyZ/W6WzkIWyFx0N9Vb9nqga7wAHMvsX5DMSjWYDvRx2szE0czxIUwu9dIH+Ltm359RRZ67xxLoLYT1LCGJbodQ/Q8myptQYO8wZgGH/kN85QmggNCJrac4IU4g1WvfLANyQ9fH7IsizYIzyOf6iBbPKpygKv1LEcR7leh3DBBtvE6lU5KOvRu5n3Zey3LoBEiDu0JI29uyfAqoLFtTvBRmbJpWf2iG+4muA2x/We41Ynn9uHYUdPE8mPKBzXjHxigMsexUDIg6CC56koYhGz3BdPWeRPPj4+nu64wNPsUTyTmRloKj99iOoQWLpqvFld0Y/zrFdEu2yQHVFcBEGo+f7jKhNK3AUlHecXJwHpi0X+FxVFaDB+A5PjQBBKSIA6ZIZ5xsJUZscaJiHkfqOy1FyHBsVqSOckjVfUodmDMZgvwBn4DnRuzB7XJDkJmRtBTeQnh8O0w2xMiCK/5mbaVWLe/sQBAvbnzQ9cFIo5yd8d1ZPeuz3FTv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(76116006)(6486002)(8936002)(38100700002)(122000001)(6512007)(316002)(5660300002)(71200400001)(54906003)(33656002)(53546011)(6506007)(36756003)(38070700005)(8676002)(186003)(2906002)(508600001)(66446008)(64756008)(86362001)(83380400001)(6916009)(66556008)(66476007)(4326008)(2616005)(7416002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGhaQVlHZXhLeW5udTNRSEJEc0k0RFV6eloyeGpzK1Q5VGtpRW1DS0V5Z3Y1?=
 =?utf-8?B?eG1vTDVLVnVSMXRxZmp6aHo0TkZSSFAzSHJMVHBEcjBvVC9PTmlsa28zbXJ0?=
 =?utf-8?B?Mis5M3R4NUwyajAvSS9td1ZWRGg3d0RWQkFxUFJsSVpWUFJ1bVdsK09aOWxy?=
 =?utf-8?B?MklQMUpvdWMvM1NmcGVESUk5MEZnQXdMSGNuL3hUSEZYeWt4TE5xbitHUjVk?=
 =?utf-8?B?dzJQY2dsN2pOWmd3SVdSaktBdTU3SjhyNUxKSE9SOWRxWHlIOTRSRWlQd0sz?=
 =?utf-8?B?bENkS1kwbGF5dVB1bHA0eVhOY2todFhWV3QwdzZqNm5Eb0UrODJBdzBrQU94?=
 =?utf-8?B?cVZnL0ZGK20zNVZpWGZ4ZXgzMFVZdnA1MnJwTlk4cHg1Y0oyY3B2Uk5CTXBr?=
 =?utf-8?B?emhmSjNtV2hPTVJmUzhzZVNoNkovMWhtWE84aWphRGNHVm5DT1V2VjFvZDA3?=
 =?utf-8?B?K3dnb1BxcmZod0tZS0YvMGNJanN1Yll3RmhIT0ZKd2VOQmx6enRwQnYzUngw?=
 =?utf-8?B?TWZlb2dxWlJabTdRZHQvNUZMaXZqOXdRK1RRWW5CL1FFVDYrSlYrWllPcmpC?=
 =?utf-8?B?SzVrTWp6WUM2Y2lUaUhtTTdnaXJTMDlCKzNSZFZPenhRQWx2cjMwN0pqSjVz?=
 =?utf-8?B?em1QNmwzbnJ6NjhCakxUbjlOb2xyS1ZRYTRVSE92MndCZGpQSngxZ0krRThm?=
 =?utf-8?B?bXZ2YTZlTHpmd0ovOWhBc0RqQjIxUHJDM1dWVFZ5VXV2UlQzOHp3NHpIMnMx?=
 =?utf-8?B?S1A0RmNRY1B1YU9QQUZHMEZZWGYzeS9CTVhnVWI2VXQ5emhGQmJURmtyZE9M?=
 =?utf-8?B?ZEJPRDJZS2ZnMm9wbFQ5QTQwQ2VPZDBIb2FnMlBtYjBPTS9aeTdUNzlGWFhR?=
 =?utf-8?B?MWRHR2NRcHpwcFJ5bjFEYVpMV0gvZnlRY1Q2YThxempSeXp4ZnNsR2ZYK0ZU?=
 =?utf-8?B?NS9tdTNiaDlBUERNeDA1STFSamplRHZVK3I3OSt6ZjVNMXY2NWM4U3BkWkhl?=
 =?utf-8?B?VGYyV0xQL0RSNHcyZ0RVWFdXRGtRR3JLd3VuNmUyTStKUjhTV25tdGJGQjcz?=
 =?utf-8?B?Zkt5WlB5bDBBd0dsVm43NTVnWGRQU3YzNTlFVkVGVTRpODQ1ZE93ejRCRDJK?=
 =?utf-8?B?VlpKYWkyakFneGtESjBNMEtneGtzcDk4Y05DUllFVURpSHlWQm03NGJORlgx?=
 =?utf-8?B?V1MvckZyY3drMUxaTFhydlVKV3A1SHVqVEVIa01zbnRNUVhoNldxcXpjTTZi?=
 =?utf-8?B?bFV6VDNpdzlwZzViQTBSMDJNNHRnbmZCaDdCeWVpdHBMc3ExZXdES0V2U2dY?=
 =?utf-8?B?Y0U0b2xNbVVNb3FTQmsrQTAzeStzZ2J0TDdIVkNVejFTVkJidFJXMCtoQnls?=
 =?utf-8?B?dHdQY28vNjFoTnNFU2p5aWNRcnlhOXYyZkFGUXhNNG9LVGJUMGVXU0VJNUxR?=
 =?utf-8?B?YTRWbTdjQ05VNmEvL3BhdlBEL1QwTEZFeXBicUE3TU1QUDFWQjYwS1hDZTVy?=
 =?utf-8?B?eGJUaGZ6OFdNTEJkdGQrdWl2YVh2YjlVNGg1Mno2OERmcjlLY0I2dTY2SStq?=
 =?utf-8?B?RzUvMk1jbnVZZWRQQXhmaDRJYU5sNmJjcStMcUFXNGFiM3NLS2ZQTkhVY01Q?=
 =?utf-8?B?T0RGNC8wd2crMEFXL1Y5Ni9YblB4VDkrMk01czd3aXlocWx6TVV0c0psb1Ew?=
 =?utf-8?B?ck0vdEdKQ0NkdWJOeDcwTmthVkNtRzN5b01JTXlsZzhXWDBFOWU3NXFJZTlR?=
 =?utf-8?B?bWtqSENqR1NSOXZSNW5WTlA2aDJDZmI2Y1pWenpEV2F6N1lPL2dab3NkVEhR?=
 =?utf-8?B?Uk1UKzBoeCt4dTBkLzJHK0Q3U3RCRE1na1lNdi92UGUxZmdYQllPU1QzODNr?=
 =?utf-8?B?d2FHR21tU2RJeHdQS0crZDM2ekN1Q2gyN1JiMndGVHNaM2tCNlBSVEl2UHY2?=
 =?utf-8?B?UnVpSk1DVnBSWGg4dW45T1grb0IwbmpoSTdBTmpVR2syS0JEMzFqMVZmcVJG?=
 =?utf-8?B?bnlOM203L2dwSzd0MkNJZjVNcEpCMCs0L2Y3TjNlTy9JRGJBR2VDRUVJTXdD?=
 =?utf-8?B?ZVpTZm9meHJaeXNMMHloMlQ0ejRzNWVWc2xWQitJY1pkaTExSGJFT08wVzNV?=
 =?utf-8?B?N1ZBYU9xTUtVSnVIeit0QUNud09ibG11SG1LUzRrK1M3OHNtVE1tTThNVWor?=
 =?utf-8?Q?nr8guQ842zdfg0c5kc2ihdk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <273F395F23A9914D8D7C4EEC843F92D1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3916b785-59f5-435d-f2cc-08d9a09ed981
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 20:57:16.2949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UrrcqI+CQ1UkMMeG2l3Kb+VsSomfyLfhQ/+uVLxd7DWpdraxNsxsPDGsrrW7HXviLmO6ApGZa/qGp4D8Bm4jsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6471
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

DQo+IE9uIE5vdiA1LCAyMDIxLCBhdCAxOjM4IFBNLCBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4
LWZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gDQo+IEZyb206IE5hZGF2IEFtaXQgPG5hbWl0QHZt
d2FyZS5jb20+DQo+IFN1YmplY3Q6IG1tL21lbW9yeS5jOiB1c2UgY29ycmVjdCBWTUEgZmxhZ3Mg
d2hlbiBmcmVlaW5nIHBhZ2UtdGFibGVzDQo+IA0KPiBDb25zaXN0ZW50IHVzZSBvZiB0aGUgbW11
X2dhdGhlciBpbnRlcmZhY2UgcmVxdWlyZXMgYSBjYWxsIHRvDQo+IHRsYl9zdGFydF92bWEoKSBh
bmQgdGxiX2VuZF92bWEoKSBmb3IgZWFjaCBWTUEuICBmcmVlX3BndGFibGVzKCkgZG9lcyBub3QN
Cj4gZm9sbG93IHRoaXMgcGF0dGVybi4NCj4gDQo+IENlcnRhaW4gYXJjaGl0ZWN0dXJlcyBuZWVk
IHRsYl9zdGFydF92bWEoKSB0byBiZSBjYWxsZWQgaW4gb3JkZXIgZm9yDQo+IHRsYl91cGRhdGVf
dm1hX2ZsYWdzKCkgdG8gdXBkYXRlIHRoZSBWTUEgZmxhZ3MgKHRsYi0+dm1hX2V4ZWMgYW5kDQo+
IHRsYi0+dm1hX2h1Z2UpLCB3aGljaCBhcmUgbGF0ZXIgdXNlZCBmb3IgdGhlIHByb3BlciBUTEIg
Zmx1c2ggdG8gYmUNCj4gaXNzdWVkLiAgU2luY2UgdGxiX3N0YXJ0X3ZtYSgpIGlzIG5vdCBjYWxs
ZWQsIHRoaXMgY2FuIGxlYWQgdG8gdGhlIHdyb25nDQo+IFZNQSBmbGFncyBiZWluZyB1c2VkIHdo
ZW4gdGhlIGZsdXNoIGlzIHBlcmZvcm1lZC4NCj4gDQo+IFNwZWNpZmljYWxseSwgdGhlIG11bm1h
cCBzeXNjYWxsIHdvdWxkIGNhbGwgdW5tYXBfcmVnaW9uKCksIHdoaWNoIHVubWFwcw0KPiB0aGUg
Vk1BcyBhbmQgdGhlbiBmcmVlcyB0aGUgcGFnZS10YWJsZXMuICBBIGZsdXNoIGlzIG5lZWRlZCBh
ZnRlciB0aGUNCj4gcGFnZS10YWJsZXMgYXJlIHJlbW92ZWQgdG8gcHJldmVudCBwYWdlLXdhbGsg
Y2FjaGVzIGZyb20gaG9sZGluZyBzdGFsZQ0KPiBlbnRyaWVzLCBidXQgdGhpcyBmbHVzaCB3b3Vs
ZCB1c2UgdGhlIGZsYWdzIG9mIHRoZSBWTUEgZmxhZ3Mgb2YgdGhlIGxhc3QNCj4gVk1BIHRoYXQg
d2FzIGZsdXNoZWQuICBUaGlzIGRvZXMgbm90IGFwcGVhciB0byBiZSByaWdodC4NCj4gDQo+IFVz
ZSB0bGJfc3RhcnRfdm1hKCkgYW5kIHRsYl9lbmRfdm1hKCkgdG8gcHJldmVudCB0aGlzIGZyb20g
aGFwcGVuaW5nLiANCj4gVGhpcyBtaWdodCBsZWFkIHRvIHVubmVjZXNzYXJ5IGNhbGxzIHRvIGZs
dXNoX2NhY2hlX3JhbmdlKCkgb24gY2VydGFpbg0KPiBhcmNoJ3MuICBJZiBuZWVkZWQsIGEgbmV3
IGZsYWcgY2FuIGJlIGFkZGVkIHRvIG1tdV9nYXRoZXIgdG8gaW5kaWNhdGUgdGhhdA0KPiB0aGUg
Zmx1c2ggaXMgbm90IG5lZWRlZC4NCg0KSHVnaCBjb3JyZWN0bHkgaW5kaWNhdGVkIHRoYXQgSSBt
YWRlIGEgc2lsbHkgYnVnLCBhbmQgdGhpcyBwYXRjaCBpcyBub3QNCmhlYWxwaW5nLg0KDQpOb3Ro
aW5nIHdvdWxkIGV4cGxvZGUsIGJ1dCBJIGFzc3VtZWQgdGhlIHBhdGNoIHdvdWxkIGJlIGRyb3Bw
ZWQgZm9yIG1lDQp0byBzdWJtaXQgdjIuDQoNCknigJlsbCBzZW5kIGEgZml4IHRvIHRoaXMgZml4
IGluc3RlYWQgdW5sZXNzIGl0IGlzIGRyb3BwZWQuDQoNCg==
