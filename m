Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2050.outbound.protection.outlook.com [40.107.241.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32A16DC15;
	Mon, 22 Jul 2024 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721668702; cv=fail; b=dMxK2TKbDF+KAqiO5vCQc+2rtajKbF7YMf5Dlu0xsfWsu+VxHud87GfOdppi8YJDODwUKdytTL0yg6uWvRuzrkV32bcYjXytpGQ4Jppx3yWwrXnBzTiagHEIj7iWv0IOzKc1qtecdbhMSq0YP6TNF47ml/i5yd2xQbX4W7fctdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721668702; c=relaxed/simple;
	bh=mjH1FHfYmVaA1oR4QA2H8X0pn4SFPdQ02aBXZwohLtw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2Wdp1sWlfH+uDjRji8yfRJvAaVa1BDRd0rIIm+vhEreCMhL1CFAeWN/fAieuH0iMJG8EEpXcpYdX2gJkbg9r5M4coWhAK4qAR70AZGNR8jzRHchLOiqIh9MAmD0iUdD5pnyCCg/rNPbv9Te7arHHDpiAgmGiIqO4VlT7MtjpbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs-soprasteria.com; spf=pass smtp.mailfrom=cs-soprasteria.com; dkim=pass (2048-bit key) header.d=cs-soprasteria.com header.i=@cs-soprasteria.com header.b=F7xbjGdX; arc=fail smtp.client-ip=40.107.241.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs-soprasteria.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs-soprasteria.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs-soprasteria.com header.i=@cs-soprasteria.com header.b="F7xbjGdX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/qTf5MFsjVthciEMNvBjuUzo+orBKHGE41So7yyaQXSghcsxG8CaOmjTiDzvxezVtLOuBEAfAw7CdVZDjxcI/jB3WO5D8eyreK2PjAe44zhR7rfjJNSxtA/8EbzNwpk4oSJiJfXigjfoxVB3NYys54UgKYMXEqJacxmyCS6RGLZwahUSnTfsgtBvqjVmKPGjbuNLmtwbkgQyl8G0hHwUVH2NSDZLtQp358Eu8y3psHrNGqr6VoJBN6RJqsHqGSps40PJxaouSrF3WFugo5Dvms4cp9Dc9jIUXGYMNUQzqWVl58OkJ6b8kgYnhnCtdUvC8A6YpuJbrMyycWxpo/k+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjH1FHfYmVaA1oR4QA2H8X0pn4SFPdQ02aBXZwohLtw=;
 b=PNpW2wxa/6kZmQ4x+smNTRJZbLzB/ZJBLtvKnl4vQfao3t6ukLd4Dz7gRwn8+flvnhCRWKboAv0mqc96fmS4dOqtNZrc+DPioLa3v7di6t4wQx3cS/t/ZRs/ce5ujupFz6ycW0IgLtdDJJ1lbxiXm6XWB+LUTCygs1/5vg6Rf9vXvYPMTbCwFFLugaUnWha55vdR6aFxBfMDvCw/fp+9x2OOwXXZaj7WTYbhJ/MpChn4mcXLxesIMUQG0Br3KKyXDAQDIh4FLx54hPZZWAw57d9Y7t5fjri79uhQ82ZWaAjekPmMk3Gt1lGWl6zZjGI1Gz7U+T5LEWhfAUvekAW9eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cs-soprasteria.com; dmarc=pass action=none
 header.from=cs-soprasteria.com; dkim=pass header.d=cs-soprasteria.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs-soprasteria.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjH1FHfYmVaA1oR4QA2H8X0pn4SFPdQ02aBXZwohLtw=;
 b=F7xbjGdXyG9dWo+Hr0xqGYZFsXQ24OTvX6yJch4KpKhpgcMKjHRwPOVllyfRU1ActBdJjSrmW3LqDNa6ccGu11tz1CAHlEdLed0zTxQ0ty1AtghFsaDijmvh6I0r7X2t4WNprtbEl0Q8Jf+ZmwarnpK9d/JRxixiMohLKsElExr6ElhJqLYdalqHLw8K9e6JrdBKkUdQsc1Gsoabuqd/eEapLrXatXxE1jXl0u2SKTQktnpOCVgD/y3BUdiUkmO/IlmcA0FHgZHGgeUcRvgFreviU2YwCTmsyKBfXJHk9FDIpnR58rG6z9EbXZ1YXNcHnJ7u6Heo4iHmvlIeyiP3tQ==
Received: from AM0PR07MB4962.eurprd07.prod.outlook.com (2603:10a6:208:f3::19)
 by GV1PR07MB10167.eurprd07.prod.outlook.com (2603:10a6:150:200::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.9; Mon, 22 Jul
 2024 17:18:17 +0000
Received: from AM0PR07MB4962.eurprd07.prod.outlook.com
 ([fe80::6724:2919:9cbb:2bb2]) by AM0PR07MB4962.eurprd07.prod.outlook.com
 ([fe80::6724:2919:9cbb:2bb2%5]) with mapi id 15.20.7784.013; Mon, 22 Jul 2024
 17:18:17 +0000
From: LEROY Christophe <christophe.leroy2@cs-soprasteria.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "mm-commits@vger.kernel.org"
	<mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MM updates for 6.11-rc1
Thread-Topic: [GIT PULL] MM updates for 6.11-rc1
Thread-Index: AQHa27jCEoghGShY3EusEEHWOlb2L7IC/tUA
Date: Mon, 22 Jul 2024 17:18:17 +0000
Message-ID: <8a6943ab-7536-4d92-b5ca-76de96e9ac85@cs-soprasteria.com>
References: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
In-Reply-To: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cs-soprasteria.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR07MB4962:EE_|GV1PR07MB10167:EE_
x-ms-office365-filtering-correlation-id: d5c54e43-6878-41a0-5b37-08dcaa7246d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UFA5UWV1aWMrelUwR3d2cVFGWlhWK25uMVdUbmhXcWNQOGpTNDN5S2M0NEhQ?=
 =?utf-8?B?Q2lqdVJvQTZjVXJiZys2WDZwS0ZHSDh3eHltMVY5dWJoelNmTFE3a0NqSDA4?=
 =?utf-8?B?Mzc5RThrU3M5dE9DWmx6MUVtZzZhcW1tZFBzSDd5NmJkNndKMkFnU1J0aHdR?=
 =?utf-8?B?aVpNeWxzQStYR3lybThLRHRqaUdsS2Foc040R2M5Q0Y5b0lIK25ZTXg5Lzgx?=
 =?utf-8?B?NEx4RFVsU3N3UFlnSG10NkQ0bUl0ZzJzOUtIRVZmZlVMSjJKOUpOdEpQTHpD?=
 =?utf-8?B?ZUN0NTZ2aVQzdGV5bjg1UjRzbHp3cllRY09PdmZkYXFzMzdwQnhvUGlqRExQ?=
 =?utf-8?B?TXVrYXp3RzdFdjlUcDZXOEtiamhqdTJReEt2bzltTG5uVDFJSmJ5a0xzWnRq?=
 =?utf-8?B?R1dXN1RFa1hzbGZ3NUdhSzMyY1lTOWdVZFdhcTJMbUtJTWJINi9VMDJiM2hK?=
 =?utf-8?B?cFN5dHJTbzZUN0x4YmxCUkJMMm81dzQ1OEZRcEZrRmNlSTl0ZnhtWmFpQzVX?=
 =?utf-8?B?UFVvV0VxNm5QTVlFWEh3Mm5SeGswWHExVmFUb2F1OEE0WnpBa0dEaG9zZzAz?=
 =?utf-8?B?ai94amd3ZjRjbDNzWjVOVWVyNUFiQkFwVUJFRXZWcjNYc3VDUUw5cXEzQjNO?=
 =?utf-8?B?YVJMWkxPdVF1TzcxVzFXM2RZNGp1Q29oWlM5Y3kwWEhPVlVPWVRidmk2U2c3?=
 =?utf-8?B?dEphMFUvTG8wMDVpT2lIaUhCaHJ2akdoMzZxRkZTTlV4dWpXVERjTEdZMDdZ?=
 =?utf-8?B?bTNOZnUxdC81VzdJc3EvMUZBWHFLUjZYVko2M0JabkhJS3NLMncrOFVRMklQ?=
 =?utf-8?B?aEtuMnlFaHR2RVJrdDlIcG1aSnNudEtjNmJTb0lSVCtlM282eVhtdWx1aFJO?=
 =?utf-8?B?RWhsTlFrUmtXbnRxUGpXYkR0MjlxMVBXZmI3d1ZIbGxQMHJmOGVqc3RESlZv?=
 =?utf-8?B?MkNudlNDWjBJS2NBd2xjdEQ3V1NvS1ZnYjhuWVA1NUJUMHQwZ0Z6QVVRYTlS?=
 =?utf-8?B?S0NyT0dUYXZILzJtNjhWSzExb0ZiWjJ3MDQyTlRDRlcwQkxCQlEvTnF1V2I3?=
 =?utf-8?B?YXhqZHo4WU5VK3UzOFgzUU5PRVBRMENMeVdxanRTRVZQaXA0emw4OHAyVU1x?=
 =?utf-8?B?bW9oM3N6R05tQTdzd3NUN1FmeEhRa1FWdGo3OVpKcHFZWXJpT2R2czlJWXov?=
 =?utf-8?B?ZGNFcCtHODl0WmtUM2hMTzh3N3BMYUVUc1ZSZkNaa0JVTG41c254TmdzaGIx?=
 =?utf-8?B?bzFLV2JKYUtTVWQzeWZ6NnJqUXBCK1JTVmxHWUFsakUyV24vZlJFMGFSRlBl?=
 =?utf-8?B?SW8yaDdISUxVQmloSERqeG84d3MwbTZ5VEM0bWg3OVI4b2kzb25sYW1tQ08x?=
 =?utf-8?B?SVpzQWZHYTNsL3JUU29oUUtkTXBPaWZBbUhxcjZSWlRKb29RTnl5UHJkcFo2?=
 =?utf-8?B?ZWF4cHpNVEM1MXBMcnZ5ZE14dFIvSFhBZ055bWcza1U5RUxSYzhVblRoY2RT?=
 =?utf-8?B?VmFkRTNJVWVCcklvaDlDaEJOVWlTMCtteVdRNGZYVGJJaTR0K0ZTcDBReExN?=
 =?utf-8?B?R0tvRXZrbDNHREdWRFpKOXdsWG9iSUVLdUxPbnphclNiWXUwMndCY2I4cDAy?=
 =?utf-8?B?V1UyeW9BN0NIaVZIM3pOVjRUcklHc3E1R3B0MWpvamRHTnBZTXFmRTRPTWdH?=
 =?utf-8?B?enM1RmNGYkNGSUkzRmExbUpkekg0aklpcjlHQitsZFlFeWM0WnFlVGkyZU54?=
 =?utf-8?B?TFo2NGszSkp0RzlFQlBxNzBCVGJJK0lvcnVVODVmbUVqVGpjUmtTYjRXWXNL?=
 =?utf-8?B?MitjU1M4MW9EaS9uZU9Wd0NOOUVzQnc0Nzd2bXZxbCtVTlRRQ2NlcDcvN0s0?=
 =?utf-8?B?VDhFaDZXNzNBUks4L1dBOFRjcnhiQnRPRU9Na3ZPZWVRTlE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4962.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnNqaWRYMzYxNWhkRWpUOFJ3QmVxajFwQkVnUWtFbGlQMTY5aUJiVHYrZjhy?=
 =?utf-8?B?VkV6SDMxUDVLcW95WjZhN1pwR0ZJdUV4QWVSVFFJdjdxZkRIV0lhM0NwQ3NT?=
 =?utf-8?B?UmNMVmVvQTBrVnNnMmFKYUVFa3puQlRsei9WcWdqN0tRYzBkSHgrMTMwSm43?=
 =?utf-8?B?NjlBNDg5K2lvSEVFTDZCSmVSbS9SdHk5UXlQdU5tT0M4VVhSankzZXJHNS96?=
 =?utf-8?B?cUNDWjNMZ0d3amM2c256OTBLcE9ETlB4TzcxNlJkdnFydmVjcXU2dFIwQnB4?=
 =?utf-8?B?Q1BieGhKZUVaeHAvZXNYU21PcXNmTVhBd1Z1M1R0Zy8rQndwd3ZMR1VQTkJG?=
 =?utf-8?B?cDkwZEVyVVh4SUYzVU05WlFMT1NYYjQzWFk3bTlNYnZneks2TGptOVpTVmJC?=
 =?utf-8?B?T1ZmdnVOeG8yZFo2c2wxeXlyNjhKeG13M051dDEvellpUEZnNVZXcEhjY1Rq?=
 =?utf-8?B?SHRQQ3VqNm9mV29hTG9iWDI2V0JOYlhQcDA5NG90bk5kd2d5U1EzL2FqUmMy?=
 =?utf-8?B?YnhkOWdGZDVUQmxuSEg0amtSdW9UYkZPQ0c4b0J1eWtmclZ4NG42NkVxWThG?=
 =?utf-8?B?NStXTUZVZFJNZXk2M1B0ekxQWTRVQmNwYWRUTUU1L2k0UitSbVN1RUZqV09O?=
 =?utf-8?B?aHZqUDlmVzNqM24vOTFpMFQwOHl5aFlXSk9qNllVTGRUc2UzeWx4bkdTb0Zq?=
 =?utf-8?B?ZmRoNTlMaVFnSVQ5bnJ3bjVpQ3BiQlFsRXRGVUgvekJ6aFIreTk4NzZUclpM?=
 =?utf-8?B?UnAwMGNRdVpiMm9LV0lmaTdtTEMxTVNuYmlqWHpkZ0F1SEZBS1VKVXVCUkRJ?=
 =?utf-8?B?RkwvclFnRW1KSmk3SjRSczRZMSt3UFNSSlRoTDlMQlZYWVp6d0lQRGs1TCtW?=
 =?utf-8?B?RFM2MGhHRG5DKzk3dGlZWkNkai9SdTVmOG5NRHo3N1Jya0I1cmRQUkptYWZ4?=
 =?utf-8?B?Mk1jRlF2ejQ1WTRDakN2U0FuK2Y1ekFIT0t2TDlvbUlHOUhKcHp0L3pESk5y?=
 =?utf-8?B?VjB1OGZUbWcyU2RMMHpGUFAxTi9JR2VydWxXME5XRDFlZ2g2NktYVVJ4eEcv?=
 =?utf-8?B?Mm9DMGV1cGczZTZEWmR3WWNIOWJIbnNhREY4dU51V21SVlI0c21MUTZWMlJY?=
 =?utf-8?B?U1Vac0krSE5aMXZtU1JhVnpkWUdXQzhJcEpSZjQ3RW9meHphbkxEQjFEODdo?=
 =?utf-8?B?UmtCc0hWbDhFKzhUb2FLWURhcXl1SXpDWGF6ZFhxNnhYdFg1RjNKTWxyY3NX?=
 =?utf-8?B?dm1ZV3ljcnB5dWRNcTlpM284QTE0Mmh1ZWlTME5DdmdzZjlDUElhUnovdGRG?=
 =?utf-8?B?OTc4c2VYa0Qvbmc2bENiSmdFN0pYeUpQMzczYlRhQURRR0c4RGVrNzJBSkor?=
 =?utf-8?B?S2dESWF6NFpDT3Z5RDE0VG5jTEpoMHpLNnBJelByMS9CNHpoVndqdWV1TUtQ?=
 =?utf-8?B?dzFKbTlrNVloTkFMd2k0TDd2ZU53dDV2ZlB3MHRDVVJRcVZ3ajVqWXpHTjdV?=
 =?utf-8?B?dHAxNE9Vd2dQdENuTS9VRVRoYmttL3krSXgvMzVUR2FuRjJLNXZkL3g4cjFv?=
 =?utf-8?B?c1FkbFVlbURGV1ZMS3N5Y1BOcWliOW9HMFdyNWtiNThNaXlHenZIVDNjejE5?=
 =?utf-8?B?MDJ1OGhXSUpHamF4RDlsL3ErYTlqbXNneWJ6NVVQeGkzM3RNY2ZNVDRwR3FS?=
 =?utf-8?B?bGd3eEMzeEpjbUE5K3dtSG1qMmw0QS9xdzllMkNZQ3dSSlNCQkY4d0hNMnZ6?=
 =?utf-8?B?bk9zbThhdUNFaUZHWVV1aisxdkFSd2FuWW9lZG9abVhDUUc0aGRTWWl0Y0JF?=
 =?utf-8?B?UWNlQVJOSzJ4d2I2UmgxUWwvTlRGQTFrZUVLd0lLYVAxRkt4WFZZYk1GYmZF?=
 =?utf-8?B?QU8zMFVDMFB1RDVIbnc1eit4WkV3V1J1MWh6d2dnL1ZDVnFNZEVHemhHVWVP?=
 =?utf-8?B?S01nZ2tsOEtrTUFodTN4NVNlZVp6S0pSNUxJUXVyaWhOYzV2ZGdaNkEvVFo5?=
 =?utf-8?B?RlJ0T1c3dWVnaGR2YmlqNTUrL3BRNFpzTVNuT281ZkJmWHR5eXhkY3dkeFVU?=
 =?utf-8?B?ZklMcmgrYkRCNy94M2swYm5EMjhKdFA3NUpJdnN0cDkwU045YWg3K0tkd2dG?=
 =?utf-8?B?Zlp0azJuaysrMGtQNGlBNEt6WjRrTTlsVTlDM3djV1JURytVSENJZ0dVRnI0?=
 =?utf-8?B?TUlkYUd5bnl1TEk0Rm1OaStOZlc4YXVZVWtDanUwbCszdEhzK0dIZU5uaUJU?=
 =?utf-8?B?MVYxa0llNUVGRkxEQ3dVbXdjUlB3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3496E2057BEEAE499DF13813F4B5485F@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cs-soprasteria.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4962.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c54e43-6878-41a0-5b37-08dcaa7246d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2024 17:18:17.0671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8b87af7d-8647-4dc7-8df4-5f69a2011bb5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TggEEXXFc6y3hakUgV4fVQyAOdZOF8BLzX6TFE/mAr0lAl2SVy2Vu9hiOu7zqW7pzU+Yi3YvpI7CivPpCYF4XYswDl2gBbmkhHnYaW9ACedvDgoT+muMJZc6UXPAyOEx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR07MB10167
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: AM0PR07MB4962.eurprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-originalclientipaddress: 2a01:cb16:46:4387:4f42:54b0:22d0:309b
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: GV1PR07MB10167.eurprd07.prod.outlook.com

DQoNCkxlIDIxLzA3LzIwMjQgw6AgMjM6NTQsIEFuZHJldyBNb3J0b24gYSDDqWNyaXTCoDoNCj4g
DQo+IExpbnVzLCBwbGVhc2UgcHVsbCB0aGlzIGN5Y2xlJ3MgTU0gdXBkYXRlcywgdGhhbmtzLg0K
PiANCj4gDQo+IA0KPiAtIE1pY2hhZWwgRWxsZXJtYW4gaGFzIGRldmVsb3BlZCB0aGUgc2VyaWVz
ICJSZWltcGxlbWVudCBodWdlIHBhZ2VzDQo+ICAgIHdpdGhvdXQgaHVnZXBkIG9uIHBvd2VycGMg
KDh4eCwgZTUwMCwgYm9vazNzLzY0KSIuICBUaGlzIHBlcm1pdHMNCj4gICAgdXNlcnNwYWNlIHRv
IHVzZSBhbGwgYXZhaWxhYmxlIGh1Z2UgcGFnZSBzaXplcy4NCj4gDQoNCkFuZHJldywNCg0KVGhh
dCBzZXJpZXMgaXMgbm90IGZyb20gTWljaGFlbCBidXQgZnJvbSBtZS4NCg0KVGhlIHB1cnBvc2Ug
b2YgdGhlIHNlcmllIHdhcyB0byBlbmFibGUgcmVmYWN0b3Jpbmcgb2YgZGlmZmVyZW50IHBhZ2Ug
DQp3YWxrZXIgd2l0aG91dCBoYXZpbmcgdG8gaGFuZGxlIGh1Z2VwZCB3aGljaCB3YXMgc3BlY2lm
aWMgdG8gcG93ZXJwYy4NCg0KVGhlcmUgaXMgbm8gY2hhbmdlIGZvciB1c2Vyc3BhY2UuDQoNClRo
YW5rcw0KQ2hyaXN0b3BlDQo=
