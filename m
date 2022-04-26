Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13C0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 00:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiDZADg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiDZADe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:03:34 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2062.outbound.protection.outlook.com [40.107.114.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7F0B1E9
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 17:00:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHHGsajESS/Pr6Ndlv5SHDQXuURc6P+ershwpWQmDwBkZZTu2TN28AVbOVfxJhek48g6VXXSJxegiBfuiQQypwlrsnFFfLsCzU2QFWvtGC9EjsnarOfIqyq5y5wLCl5xaq3dFhzpxkQu+pRMwpe5Si3eQjw3VEEN22CKUXRr7+jeOz3/BddtsQTRlYcI0NlbQSYGPtzSbE6o82VHe87hRyuv/jngVRGJUyDbUbG5SCD3FL1rvlXsUrc+V69py37w313suDSzrBpwPaKSZbBmtrsxOPexrdYzkphhaGge5XU5QZzroz1yvAfo1VkN0PAUULsTa4SW3WtDeZF6VPdygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DyCAWhTUos96JI58arzpJW8wIA0KARxJc4qHuHoTgo=;
 b=FlyqCCYMsCnK8pW3Dt/z33jIfybXaWP//c2N1nxxGz9CrgvferlBEJnV6SlDLKiDnY/ruOncr3Dyp2H+f2ZNTg6zxbGmUZavEk2O2Hd33PGcmDO3FouEK9pJViR+uGxVJ+VUQ9hQButbQHAicFfd/ycqHe1EyjAk5OiKniRCV2P77klorAzkwUCBgo0vlzSA6YOXvbpSvRe2SW8kLrU219fq045cKK2pNKCyXqjPGX6L54PoBkbc4AG+QYCET00wajOV/QfoZlGrIdTbSOMvS7OfKpEtzapES24+RsyIWfCMkZsbG6mZbxjwajaBHkDeELBtzVZzgfIjDkWhO808EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DyCAWhTUos96JI58arzpJW8wIA0KARxJc4qHuHoTgo=;
 b=MNsDGd0t5UkFJSdPzNKUA2UfcpyMwdmcw2lDYZAJvT2V1y9h18W2/f3HZYNltVyqBO8eqAGx5esXl5jgHb3erJVt78VNJVjL+XxXF81iqRpYSIB7Ac45J65j1E/CknIeX4qWoBmzZXYmEZHl2B+ocjDVcW2aAWp8bqsqK6PBi/g=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by OSAPR01MB3652.jpnprd01.prod.outlook.com (2603:1096:604:30::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 00:00:25 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::e58f:5f3b:6d28:b245]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::e58f:5f3b:6d28:b245%4]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 00:00:25 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "anshuman.khandual@arm.com" <anshuman.khandual@arm.com>,
        Yu Xu <xuyu@linux.alibaba.com>
Subject: Re: +
 mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch added
 to -mm tree
Thread-Topic: +
 mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch added
 to -mm tree
Thread-Index: AQHYWPH4y4bwLbI6BkeXFJQeEmDPeK0BT10A
Date:   Tue, 26 Apr 2022 00:00:25 +0000
Message-ID: <20220426000024.GA3828305@hori.linux.bs1.fc.nec.co.jp>
References: <20220425221516.561D0C385A4@smtp.kernel.org>
In-Reply-To: <20220425221516.561D0C385A4@smtp.kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5f80f8c-8688-41d4-d284-08da2717c42f
x-ms-traffictypediagnostic: OSAPR01MB3652:EE_
x-microsoft-antispam-prvs: <OSAPR01MB365226A1BD4B785A68600E36E7FB9@OSAPR01MB3652.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jwQh/+BwMKUHkikWEFuKW0bq8hS3SkaqP1y01Iy0aaBd/XZYPEK5xNFwcPjS4QYFgIerWIZkziZKCPPiMLzid1AwZ+gd5KMb1VO07Be5ha2isuDcvlDP3Ei+UEla+9p53aZfStYp/cFvgI7y34RF6ss+YCgDbH5UY205Tl+u4cwO0bMGuS1GwMmUd/OJmYquFi5X27/nxbVratBr1W83dWiPLyQU5fl+wo5exUMPKPWTM66h7orOmbxVjFgZ5NlrTyjVtX9KH50a2l+6q52IJ1jdVODi7S1HEX3TaHgeoXd37x88tYPaazHwktEcTqH4KrWR1pUR4ngcYPpbt7Sji8ej2lFgfID+iSRfU9t2gCW7IIfM9vEX88PzmthS7yKBIPbJP8xphRAOXrlXirOFyIF68HSxdU+G1ZeF660oX7lSj8AoVJ7lWcaIH9C0bNfxRH6jqIxodSHvb+aeUm/4eaQl6RkSVTCVdAfF3djsrlMoBsWyFvqRkqvkNsL+7tKC9mZ7hdDW4vvwe+SmJzmiKFRJm0lteIOdAxo3iWhw0JeCYIP/GCelupeFaN6Hmfrq7o4b2nm7V3EBTnQbCOjYpMjwp0Wi0ryp+Gf2Wuz4Bu+vbzoh+6L+XJcSPJnd/Wz4ku5OQnfnktdZiGuBSp2XhWPJ78uYgaaiunE54lENL0uhbbr8x6iC/FLM3rC6lE2//ktVQm0tACVey2krGSjPaIFe9GnOrqpmcuBVPqq0Hq6AjGj2djRqEXutDZQgHQD6DdXMFlMobSso3xkZSzuD3h4zJJRjl+glmydOPu+ZenJRcq3dEThq3+OozJfKgWWh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(1076003)(186003)(71200400001)(76116006)(64756008)(66446008)(66476007)(66556008)(5660300002)(6506007)(9686003)(33656002)(6512007)(55236004)(26005)(83380400001)(85182001)(6916009)(8676002)(66946007)(8936002)(4326008)(508600001)(2906002)(122000001)(38070700005)(38100700002)(966005)(86362001)(82960400001)(6486002)(15650500001)(316002)(14583001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjNWR3c5S0lVdHZzMXJQNnRUZnJIQzdvMDJ5K0ZHeGkxZ1VuckpTSTZDdDE0?=
 =?utf-8?B?L28yd3BZVWpxTnM3NXpqSm5GYWZiVTlmbnlkY0dWU0ZJb3o1Rm0wOWhUYjF1?=
 =?utf-8?B?enI3TzhCYitCZDRhKzZicno0SWhlYjVBOCtnQm9xZFpOY0hZWXBWQ2g4NkNh?=
 =?utf-8?B?alNKTnEwTGFRczFkcnZHVGxzY0dYRDU3d0JLUUUydGdlWjZuQ2JLVk4yK2k5?=
 =?utf-8?B?L1MxZGFQM3l6cHFVMzlCUFhVV0F0YU9sdmRXODZOQVRpc3dVaHNHTE9uT1li?=
 =?utf-8?B?M3c3bDExTndyTEFNNHRpRTJUdzBKSTIxSDZGSWlxVEJKdG9XZnZKUENMN045?=
 =?utf-8?B?bGJDWVVEVCtGQ3B5b2J1STR5QnM0ZnlhcnlpL29iT1VsNERBaStpR1IyQXpS?=
 =?utf-8?B?UGt6QVRjcWo4MC9JZGhicWU0TDJUcnU3SngyY3VmcmZuUS90aEc3ZCtrcHg1?=
 =?utf-8?B?Y1RsS1dKRkdLRVBpYTNYa2E5SGdqYTNJaDl3N082S3l1cVFHWndqYk1IQWVN?=
 =?utf-8?B?N3RreXJtNm1aZkI2Y0JlMVRTL05nZ3BHK05VaTlZcVhlS1E2aUtMZlYzVWVK?=
 =?utf-8?B?aEk5dzJjbmVhYU11THo3SlBNZXk0clNZek9NUzFhYit1QUpUdVh1elUxWS9a?=
 =?utf-8?B?b3lmMUZJQ1RxMWUzT3ZnKy9DOGhFeVZiVWNGVTF1NGJ5NVQwWkg0SjduV0s3?=
 =?utf-8?B?aHNITlEyV2drNS92UXhDNmZ2cDVDczNzWFo0enBNeXpoT2U4VnFnNkc4UXJN?=
 =?utf-8?B?U0EzNFpSSGNZN1E5NmdJY3Z1VXFWM0VZUEV6YnJDQnNMc05JZ0ozaXUvc0Rv?=
 =?utf-8?B?YmhxUlE5eWNmTWtiZzBzN0tyOG9QY2w0TkdyVlpkZGp0WHBIdlE0cm8wWU8w?=
 =?utf-8?B?dG1CaDh3YXgvQnJycnpZWGZqZDE1MWpBaStFVUhYWEswMmVMVjZTdFFSVkdR?=
 =?utf-8?B?L29aN09vWnpSK1k0WU9iQ0ovK09sdmNWWk1LbEl1b2pRTC92UVZKZjROZEdZ?=
 =?utf-8?B?cW42WXVtWklCMUNHSDlQQlk4K0g3WFl2VTFFWTNkaGxDUlhaMkVzMmRydUps?=
 =?utf-8?B?K0RzeEYvMllaUVFBT0dUdS9LYXMwV3JnYnJ2eTJLK1JockdibE1uOWVxRE5t?=
 =?utf-8?B?V2xyb1BUcnNvVlNDeXU0UWc4emVlYXZnaW0wVzFWVnUzSEFhczQzR0hvZGJR?=
 =?utf-8?B?RDlnUEY2YjU4WDBIRXVmeXFEWjRZZi9TOHZTUDRIWWVjMnMzbFhqWU0xaWsz?=
 =?utf-8?B?S3dTZDdnM1FIN29lSDIyc0k1WXBUU2RNL3hOWTQ3bS9tK3c3VWhxNmJwYXho?=
 =?utf-8?B?SzliNGd5ZE4rUFNRN1B0SE9VYmZHd2Z2M05yMlVYclBacjZXeWhqMHZFNjdy?=
 =?utf-8?B?T3BESzBud204dUZQNXRXaEkwYlQ4cXhYZmMrZDRia3o3d2xZeTUvcndoS09M?=
 =?utf-8?B?eW1XMFNsYk5PVUhQdXppaGd0ZDdwVmxpekM1UjFnNDAwa1h4cS9hT0g5V2R0?=
 =?utf-8?B?SWhOaDRVVkF5YU5qUDdGVW1kSkJFV3htc0RHVDhCa3cxcVFmZkJhSFg4Y2Qx?=
 =?utf-8?B?a25BZ1lwOWRkU0FsMFNhVHhSR2NmWkpoMDZBMzZwTktmdUR5M3ZJdzRNSEl0?=
 =?utf-8?B?bUdiNGNlZ2pHeEtxWXZNaENaOW1RaWRlU09pMmlZcDNPMVA0STFVaTkxVjJS?=
 =?utf-8?B?Si9nOUJOTGNUaUdrQjVBcDloL2xiVlZLdTdCRmdhN1A1blJEZ2FqU2VSaDRE?=
 =?utf-8?B?VnNDTHg2ZUU3bGFvOVlNVnRKSFYvbGgyaDN6TEJYT2ZTN3lGZTE3S2o5SHk2?=
 =?utf-8?B?Y0c0UGo5RnVrdEhoRHVWT0NVMzNGeE5pb2Q1QlVsRmJ2ZldaSjhOVXNjMUpv?=
 =?utf-8?B?YjdoOEV0NkZUVkwzT3YxNzlaSytnZU1BSWpjb0ZMU3ZjWjlXWTV4QitJSWFI?=
 =?utf-8?B?ajhKUnZKVUx3emNVb2ZvWndxSjhrNktNMmd5SXN0Unp0K1FybTVzdVJzK3hD?=
 =?utf-8?B?TUh2WHhLSHJYbkFHa2JKT1J2bllXQmRRL3ZMOE50T3ZMR2dJVXNOYTVZWElV?=
 =?utf-8?B?aHZKQkE4d0kxdXBZTHYrV2NaOHB4MUEyUUluNDN0a3VUeElkSDZ0U0dwQ29z?=
 =?utf-8?B?cnVPcGVNZFhSa0locWZGb2xZVmdRd2pwc055YTZ1RXA2b203MmpOQ3B5aWp3?=
 =?utf-8?B?NG9RUTUwVGYxMkVFMFJBdnZ5RXRyeDBGK25pZmpUdDFJelRzSUYzKytSSWVk?=
 =?utf-8?B?QlpCV3ZrcEFIME9TL21jOVlCZHpyNERGdHpnTVB4QTFBYWw2c3pKREc5RWp2?=
 =?utf-8?B?d2ZuUTdwR1ZhT0c4aE0wRSs1M2M1VGhGbTdxaTdidjgwVWRKVUFUWGlNcWhr?=
 =?utf-8?Q?K3GDrURk0TpXUClU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <450B524F5527BC4F8803C8B1A53D2713@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f80f8c-8688-41d4-d284-08da2717c42f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 00:00:25.4921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C+gxv0BMz5GixG7lnZ6/IMeLmuK8SDI0Z/OUh5v/16Del0CEDprrXSKC+JS4QvwIZM4UUXh6jUr2uJYxw2WhqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3652
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

SGksDQoNClRoYW5rIHlvdSBmb3Igd29ya2luZyBvbiB0aGlzLiAgVGhpcyBwYXRjaCBkZXBlbmRz
IG9uIGNvbW1pdCBkMTczZDU0MTdmYjYNCigibW0vbWVtb3J5LWZhaWx1cmUuYzogc2tpcCBodWdl
X3plcm9fcGFnZSBpbiBtZW1vcnlfZmFpbHVyZSgpIikgd2hpY2ggd2FzIGENCmJpdCBwcmVtYXR1
cmVseSBtZXJnZWQgaW50byBtYWlubGluZS4gIFRoZSBwcm9wb3NlciB3b3VsZCBsaWtlIHRvIHN1
Ym1pdA0KYW5vdGhlciB2ZXJzaW9uIG9mIGZpeCBpbiB0aGUgYWdyZWVkIGFwcHJvYWNoLCBhbmQg
ZDE3M2Q1NDE3ZmI2IHdpbGwgYmUNCmxpa2VseSB0byBiZSByZXZlcnRlZC4gIFNvIGNvdWxkIHlv
dSBkcm9wIHRoaXMgcGF0Y2ggZnJvbSBsaW51eC1tbSBmb3Igbm93DQp0byBhdm9pZCB0aGUgY29u
ZnVzaW9uIGR1ZSB0byB0aGUgY29uZmxpY3QuDQoNClRoYW5rcywNCk5hb3lhIEhvcmlndWNoaQ0K
DQpPbiBNb24sIEFwciAyNSwgMjAyMiBhdCAwMzoxNToxNVBNIC0wNzAwLCBBbmRyZXcgTW9ydG9u
IHdyb3RlOg0KPiANCj4gVGhlIHBhdGNoIHRpdGxlZA0KPiAgICAgIFN1YmplY3Q6IG1tL21lbW9y
eS1mYWlsdXJlOiBhZGQgbmV3IG1lbW9yeSBmYWlsdXJlIG1lc3NhZ2UgTUZfTVNHX0hVR0VfWkVS
Tw0KPiBoYXMgYmVlbiBhZGRlZCB0byB0aGUgLW1tIHRyZWUuICBJdHMgZmlsZW5hbWUgaXMNCj4g
ICAgICBtbS1tZW1vcnktZmFpbHVyZS1hZGQtbmV3LW1lbW9yeS1mYWlsdXJlLW1lc3NhZ2UtbWZf
bXNnX2h1Z2VfemVyby5wYXRjaA0KPiANCj4gVGhpcyBwYXRjaCBzaG91bGQgc29vbiBhcHBlYXIg
YXQNCj4gICAgIGh0dHBzOi8vb3psYWJzLm9yZy9+YWtwbS9tbW90cy9icm9rZW4tb3V0L21tLW1l
bW9yeS1mYWlsdXJlLWFkZC1uZXctbWVtb3J5LWZhaWx1cmUtbWVzc2FnZS1tZl9tc2dfaHVnZV96
ZXJvLnBhdGNoDQo+IGFuZCBsYXRlciBhdA0KPiAgICAgaHR0cHM6Ly9vemxhYnMub3JnL35ha3Bt
L21tb3RtL2Jyb2tlbi1vdXQvbW0tbWVtb3J5LWZhaWx1cmUtYWRkLW5ldy1tZW1vcnktZmFpbHVy
ZS1tZXNzYWdlLW1mX21zZ19odWdlX3plcm8ucGF0Y2gNCj4gDQo+IEJlZm9yZSB5b3UganVzdCBn
byBhbmQgaGl0ICJyZXBseSIsIHBsZWFzZToNCj4gICAgYSkgQ29uc2lkZXIgd2hvIGVsc2Ugc2hv
dWxkIGJlIGNjJ2VkDQo+ICAgIGIpIFByZWZlciB0byBjYyBhIHN1aXRhYmxlIG1haWxpbmcgbGlz
dCBhcyB3ZWxsDQo+ICAgIGMpIElkZWFsbHk6IGZpbmQgdGhlIG9yaWdpbmFsIHBhdGNoIG9uIHRo
ZSBtYWlsaW5nIGxpc3QgYW5kIGRvIGENCj4gICAgICAgcmVwbHktdG8tYWxsIHRvIHRoYXQsIGFk
ZGluZyBzdWl0YWJsZSBhZGRpdGlvbmFsIGNjJ3MNCj4gDQo+ICoqKiBSZW1lbWJlciB0byB1c2Ug
RG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1pdC1jaGVja2xpc3QucnN0IHdoZW4gdGVzdGluZyB5
b3VyIGNvZGUgKioqDQo+IA0KPiBUaGUgLW1tIHRyZWUgaXMgaW5jbHVkZWQgaW50byBsaW51eC1u
ZXh0IGFuZCBpcyB1cGRhdGVkDQo+IHRoZXJlIGV2ZXJ5IDMtNCB3b3JraW5nIGRheXMNCj4gDQo+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiBGcm9tOiBBbnNodW1hbiBLaGFuZHVhbCA8YW5zaHVtYW4ua2hhbmR1YWxAYXJtLmNvbT4NCj4g
U3ViamVjdDogbW0vbWVtb3J5LWZhaWx1cmU6IGFkZCBuZXcgbWVtb3J5IGZhaWx1cmUgbWVzc2Fn
ZSBNRl9NU0dfSFVHRV9aRVJPDQo+IA0KPiBNZW1vcnkgZmFpbHVyZSBqdXN0IGdldHMgaWdub3Jl
ZCBmb3IgZ2xvYmFsIGh1Z2VfemVyb19wYWdlIGV2ZW4gd2l0aG91dCBhDQo+IHNwbGl0IGF0dGVt
cHQuICBCdXQgY29ycmVzcG9uZGluZyBtZW1vcnkgZmFpbHVyZSBtZXNzYWdlDQo+IE1GX01TR19V
TlNQTElUX1RIUCBpcyBtaXNsZWFkaW5nIGFzIGlmIHRoZSBUSFAgcGFnZSBjb3VsZCBub3QgYmUg
c3BsaXQNCj4gZHVyaW5nIG1lbW9yeSBmYWlsdXJlIGhhbmRsaW5nLiAgVGhpcyBhZGRzIGEgbmV3
IG1lc3NhZ2UgTUZfTVNHX0hVR0VfWkVSTw0KPiBpbmRpY2F0aW5nIHRoYXQgbWVtb3J5IGdvdCBp
Z25vcmVkIGZvciBiZWluZyBhIGh1Z2UgemVybyBwYWdlLg0KPiANCj4gTGluazogaHR0cHM6Ly9s
a21sLmtlcm5lbC5vcmcvci8yMDIyMDQyNTA4MDMwNi4xNzcxNDgwLTEtYW5zaHVtYW4ua2hhbmR1
YWxAYXJtLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBBbnNodW1hbiBLaGFuZHVhbCA8YW5zaHVtYW4u
a2hhbmR1YWxAYXJtLmNvbT4NCj4gQ2M6IFRvbnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNvbT4N
Cj4gQ2M6IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPg0KPiBDYzogTmFveWEgSG9yaWd1
Y2hpIDxuYW95YS5ob3JpZ3VjaGlAbmVjLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IE1v
cnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gLS0tDQo+IA0KPiAgaW5jbHVkZS9s
aW51eC9tbS5oICAgICAgfCAgICAxICsNCj4gIGluY2x1ZGUvcmFzL3Jhc19ldmVudC5oIHwgICAg
MSArDQo+ICBtbS9tZW1vcnktZmFpbHVyZS5jICAgICB8ICAgIDMgKystDQo+ICAzIGZpbGVzIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gLS0tIGEvaW5jbHVk
ZS9saW51eC9tbS5ofm1tLW1lbW9yeS1mYWlsdXJlLWFkZC1uZXctbWVtb3J5LWZhaWx1cmUtbWVz
c2FnZS1tZl9tc2dfaHVnZV96ZXJvDQo+ICsrKyBhL2luY2x1ZGUvbGludXgvbW0uaA0KPiBAQCAt
MzI3NSw2ICszMjc1LDcgQEAgZW51bSBtZl9hY3Rpb25fcGFnZV90eXBlIHsNCj4gIAlNRl9NU0df
U0xBQiwNCj4gIAlNRl9NU0dfRElGRkVSRU5UX0NPTVBPVU5ELA0KPiAgCU1GX01TR19IVUdFLA0K
PiArCU1GX01TR19IVUdFX1pFUk8sDQo+ICAJTUZfTVNHX0ZSRUVfSFVHRSwNCj4gIAlNRl9NU0df
Tk9OX1BNRF9IVUdFLA0KPiAgCU1GX01TR19VTk1BUF9GQUlMRUQsDQo+IC0tLSBhL2luY2x1ZGUv
cmFzL3Jhc19ldmVudC5ofm1tLW1lbW9yeS1mYWlsdXJlLWFkZC1uZXctbWVtb3J5LWZhaWx1cmUt
bWVzc2FnZS1tZl9tc2dfaHVnZV96ZXJvDQo+ICsrKyBhL2luY2x1ZGUvcmFzL3Jhc19ldmVudC5o
DQo+IEBAIC0zNTksNiArMzU5LDcgQEAgVFJBQ0VfRVZFTlQoYWVyX2V2ZW50LA0KPiAgCUVNICgg
TUZfTVNHX1NMQUIsICJrZXJuZWwgc2xhYiBwYWdlIiApCQkJCVwNCj4gIAlFTSAoIE1GX01TR19E
SUZGRVJFTlRfQ09NUE9VTkQsICJkaWZmZXJlbnQgY29tcG91bmQgcGFnZSBhZnRlciBsb2NraW5n
IiApIFwNCj4gIAlFTSAoIE1GX01TR19IVUdFLCAiaHVnZSBwYWdlIiApCQkJCQlcDQo+ICsJRU0g
KCBNRl9NU0dfSFVHRV9aRVJPLCAiaHVnZSB6ZXJvIHBhZ2UiICkJCQlcDQo+ICAJRU0gKCBNRl9N
U0dfRlJFRV9IVUdFLCAiZnJlZSBodWdlIHBhZ2UiICkJCQlcDQo+ICAJRU0gKCBNRl9NU0dfTk9O
X1BNRF9IVUdFLCAibm9uLXBtZC1zaXplZCBodWdlIHBhZ2UiICkJCVwNCj4gIAlFTSAoIE1GX01T
R19VTk1BUF9GQUlMRUQsICJ1bm1hcHBpbmcgZmFpbGVkIHBhZ2UiICkJCVwNCj4gLS0tIGEvbW0v
bWVtb3J5LWZhaWx1cmUuY35tbS1tZW1vcnktZmFpbHVyZS1hZGQtbmV3LW1lbW9yeS1mYWlsdXJl
LW1lc3NhZ2UtbWZfbXNnX2h1Z2VfemVybw0KPiArKysgYS9tbS9tZW1vcnktZmFpbHVyZS5jDQo+
IEBAIC03MTksNiArNzE5LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBhY3Rpb25fcGFn
ZV90eQ0KPiAgCVtNRl9NU0dfU0xBQl0JCQk9ICJrZXJuZWwgc2xhYiBwYWdlIiwNCj4gIAlbTUZf
TVNHX0RJRkZFUkVOVF9DT01QT1VORF0JPSAiZGlmZmVyZW50IGNvbXBvdW5kIHBhZ2UgYWZ0ZXIg
bG9ja2luZyIsDQo+ICAJW01GX01TR19IVUdFXQkJCT0gImh1Z2UgcGFnZSIsDQo+ICsJW01GX01T
R19IVUdFX1pFUk9dCQk9ICJodWdlIHplcm8gcGFnZSIsDQo+ICAJW01GX01TR19GUkVFX0hVR0Vd
CQk9ICJmcmVlIGh1Z2UgcGFnZSIsDQo+ICAJW01GX01TR19OT05fUE1EX0hVR0VdCQk9ICJub24t
cG1kLXNpemVkIGh1Z2UgcGFnZSIsDQo+ICAJW01GX01TR19VTk1BUF9GQUlMRURdCQk9ICJ1bm1h
cHBpbmcgZmFpbGVkIHBhZ2UiLA0KPiBAQCAtMTg1OSw3ICsxODYwLDcgQEAgdHJ5X2FnYWluOg0K
PiAgCQkgKiBUT0RPOiBIYW5kbGUgbWVtb3J5IGZhaWx1cmUgb2YgaHVnZV96ZXJvX3BhZ2UgdGhv
cm91Z2hseS4NCj4gIAkJICovDQo+ICAJCWlmIChpc19odWdlX3plcm9fcGFnZShocGFnZSkpIHsN
Cj4gLQkJCWFjdGlvbl9yZXN1bHQocGZuLCBNRl9NU0dfVU5TUExJVF9USFAsIE1GX0lHTk9SRUQp
Ow0KPiArCQkJYWN0aW9uX3Jlc3VsdChwZm4sIE1GX01TR19IVUdFX1pFUk8sIE1GX0lHTk9SRUQp
Ow0KPiAgCQkJcmVzID0gLUVCVVNZOw0KPiAgCQkJZ290byB1bmxvY2tfbXV0ZXg7DQo+ICAJCX0N
Cj4gXw0KPiANCj4gUGF0Y2hlcyBjdXJyZW50bHkgaW4gLW1tIHdoaWNoIG1pZ2h0IGJlIGZyb20g
YW5zaHVtYW4ua2hhbmR1YWxAYXJtLmNvbSBhcmUNCj4gDQo+IG1tLWRlYnVnX3ZtX3BndGFibGUt
ZHJvcC1wcm90ZWN0aW9uX21hcC11c2FnZS5wYXRjaA0KPiBtbS1tbWFwLWNsYXJpZnktcHJvdGVj
dGlvbl9tYXAtaW5kaWNlcy5wYXRjaA0KPiBtbS1tbWFwLWFkZC1uZXctY29uZmlnLWFyY2hfaGFz
X3ZtX2dldF9wYWdlX3Byb3QucGF0Y2gNCj4gcG93ZXJwYy1tbS1lbmFibGUtYXJjaF9oYXNfdm1f
Z2V0X3BhZ2VfcHJvdC5wYXRjaA0KPiBhcm02NC1tbS1lbmFibGUtYXJjaF9oYXNfdm1fZ2V0X3Bh
Z2VfcHJvdC5wYXRjaA0KPiBzcGFyYy1tbS1lbmFibGUtYXJjaF9oYXNfdm1fZ2V0X3BhZ2VfcHJv
dC5wYXRjaA0KPiBtbS1tbWFwLWRyb3AtYXJjaF9maWx0ZXJfcGdwcm90LnBhdGNoDQo+IG1tLW1t
YXAtZHJvcC1hcmNoX3ZtX2dldF9wYWdlX3BncHJvdC5wYXRjaA0KPiBtbS1tZW1vcnktZmFpbHVy
ZS1hZGQtbmV3LW1lbW9yeS1mYWlsdXJlLW1lc3NhZ2UtbWZfbXNnX2h1Z2VfemVyby5wYXRjaA==
