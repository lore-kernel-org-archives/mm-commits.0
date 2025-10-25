Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278B2153D3;
	Sat, 25 Oct 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761405585; cv=fail; b=fI6hZy2nn3YoigO+kORPctxdhww4za9YqJT1d6L4PcLCRZ6899PwKGkBRdesFL76tOVg9/uJELKz6nOJP1pXf4Znd7AxZrBNv3/MRypFpbY7Q4y/Khq+Y6JZvM22CO9IYvjljEw7tXZWMt0EcKJ4dmNMW8qIOUIsOsO0zEs4Elo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761405585; c=relaxed/simple;
	bh=YjZoMCAs0E50/q8wGMHUhIdW96dKF7zDWcz5fLnEBk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b0bw1CBFH+k3/pN6zPaK407v6h8Efd9Lu55prXDuE5pHkBnQ6smkT7A7+FE7HUfvaB9SzpUtIM7PDCjlBcdBR97HcFZgczc7XyKqqpYFbtsiDKByxbc6w67mz0SUDT+3uHMx9Wn/URmEyMKtZfazc2ViqLY0eVTvkbUCSYKWR6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GhqXPa+r; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GhqXPa+r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkJqG3gm2ESaogy4GvS/+KqDYEzq8alyPf+r7/nFLBHuSpXWeGCHqkrFrxr2d27ntu2obnidKmk7SCfGcP2OcbNcN5EL5Ks5AoZEgskexRn4uSp/odZFtX2Cg2GIx459+R6t5DjLGfKYj/HjrLgWl4m3GlDntoFZ0uorqUaZLR1m1Sr15Jv6AvdabM97Xb2QNJZJsmovtiSbmNCDYFTFTpoH6y8jK/9XWmE2tWWw/rtmCfuJpa9Onmukk0TGpnvr8OscvDmKAGGn2STb66OegtficR231zXJPwFRYzj+P8bEo4HggtoT3hGTgrBYqCmKkbbCRWojaJcRgSzyHoLjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEAYTv1rydYgOG5x0ustbFXgvMP9mxsD6aoLQVFchGQ=;
 b=l4RIdsVhGZuQFYp2CQ8XigvHWlYMdckIe25dW0AUZLFbKnR/GZ+EsV+edmeThpQNUrjpWzvTVlDuRUi+68BjrSPP9C8oUQIBIh3vfE/MPx6rlKAEmUECnMiFh8SEqBf3aRaxzSjHe9/EmNL7kAFyVXRahTPleCZBqR6SUDDaaZR7akdpP/xGgVq0cb+kOWLJgyRg/e6dWAkP9VY51bbM3tELj2gj4uvoq/dLfVAZ5On3iF5VktAHzQm3yvIX2woIRslNRLNyV51TpbJc8TTwCl5NJXMciKg8KDR9wlQz4pDBuEXd8gBFp6hdXlp+kk2pcvD8S7xjTiUohave3DwxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEAYTv1rydYgOG5x0ustbFXgvMP9mxsD6aoLQVFchGQ=;
 b=GhqXPa+ro+MMPv8GSUWKaCwKbNdqnRxlCgaawCNXSfxHwRpmrEuH8J0ZZvPGsDwlXlCcVj9BZVBe2gEnLm0luMgUl/7/H543p39ipHvE/39h09QE35d7YvLO13dbE3CJub+cDSXybDRpvAkbnCW9jP297ASEsl9L3NkSIfZZMLVUE5uXZKuQJQlT3JN+BNmNinJ3tmUcUtUXNQStiWAimzJ4TmsH8Dkq2iCfA9D4/l9Wt6prikE29gdMl7T5MIKU/MjbA43M3Aq9pxMVWl2MUtgXplacTFb5d5oP/rhlWxUYsrlS51Ex5BUQzZ3fjp+wZQdkwEyffOVvGRIGYnTjoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Sat, 25 Oct 2025 15:19:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Sat, 25 Oct 2025
 15:19:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yang@os.amperecomputing.com, willy@infradead.org, stable@vger.kernel.org,
 ryan.roberts@arm.com, richard.weiyang@gmail.com, npache@redhat.com,
 nao.horiguchi@gmail.com, mcgrof@kernel.org, lorenzo.stoakes@oracle.com,
 linmiaohe@huawei.com, liam.howlett@oracle.com, lance.yang@linux.dev,
 kernel@pankajraghav.com, dev.jain@arm.com, david@redhat.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org
Subject: Re: +
 mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
 added to mm-hotfixes-unstable branch
Date: Sat, 25 Oct 2025 11:19:36 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <783CBCC5-A1D0-4047-9F4A-6FBD891877DA@nvidia.com>
In-Reply-To: <86935d30-eeb5-4a38-9994-e4dfd30d3013@oracle.com>
References: <20251023231218.AECFCC4CEE7@smtp.kernel.org>
 <86935d30-eeb5-4a38-9994-e4dfd30d3013@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0219.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL3PR12MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 77303b7d-3aa5-49a2-a5ee-08de13d9ea42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a4a2f05n5ryNZxO5POQeI/eazYxPigQLfe+iRLrnfdnRsNP/7NBLi9BlLM8g?=
 =?us-ascii?Q?BPY1+nbL2nx4DNwVrKpXVLORgl/usMjrG/anuLmJvecR8CD5ivo3vua7iCwi?=
 =?us-ascii?Q?dKC2esQHFl8Dea5QnpWIzoafk24wd+lV350kDUSEqvw/wnxfnR+crrrEJIbl?=
 =?us-ascii?Q?F4Gxn3WNMF6mttHxs1fLS2aFwkHlhIAUQGDjwa49lrHqQ0YVGWM1vL+20tK2?=
 =?us-ascii?Q?iTyKie2CWYuHUxNXwUq+GN/b1MOsOretc4xOsliDb34jsgqXna2l+fe/TkAL?=
 =?us-ascii?Q?DsO0Kd2rjKUEaYOh3DmqdnjU4EquFTLSt+qIwEhayn8T0hiOgIhtpnC64LGe?=
 =?us-ascii?Q?/3EGWe4u8zgIQnnNFV5tCphhUuWpU0rQm6+Rip5l/0ERyNz8xFNLwZkh1mbs?=
 =?us-ascii?Q?Mb+wbzZPaY4TBhRLw8virX+j6hs5dgvOVc/CVPkZkN1M87SIHIG7KuIdZtxz?=
 =?us-ascii?Q?ne9aFBRjjTo3fxUk1S2dNK4ky03r8Z4tHrUSHITWP97M0yDN6Kw0X/bh2I0j?=
 =?us-ascii?Q?mPySXZcTTEW8S4iP/N4SMeCx55CG8k4skKyHIxDKuTG2gTEQmyNhZIpNYgNu?=
 =?us-ascii?Q?TEQRInk8/FTKMlJbfRi76r7Srl9z840lxkBUW2KzoNyDyhFPp7xAcJ3Jy9cY?=
 =?us-ascii?Q?5O8Ppkd3zNAvMUZKAnewbZdp0VeYzixTkwZbbhc3Hjjg2cJyXW3i4FfvOPtV?=
 =?us-ascii?Q?ip63SbDmNbb2s3kRKiteMOPAKwgcCSvjST5Fam7C5HYGJWh6uhtGz0yzUzIU?=
 =?us-ascii?Q?CZgZba0ewT4n8uQGQ0+YTk5veXYVzhZpzrV2ZKS7pwGIWu6tNQmxvtYl54CW?=
 =?us-ascii?Q?xw03qEDwMla5nlWueVicB6+MkAyszVIpqdh+Y/4ccoQfT3m7vXmQCWdw/XQA?=
 =?us-ascii?Q?W6yaovGfnwZlGwgkQK3TWXxPqheEhD+Iz8o2eTXhTjXEBKYV97s376mZPA75?=
 =?us-ascii?Q?naUz/oFnHw1Qe/6zcPm+zy+eZ9yV2rR7K7Euk2Pqqz69Qg3X53xoD1J5irUi?=
 =?us-ascii?Q?2H89bwYfhWpD8+LAyB1kUKENr8cvDqhh6aXk8UDnuu6dboAuJDvsTo7S9Hxu?=
 =?us-ascii?Q?y4/MMrNJvcm1BEZeZCTZbsxmfcRDVTdeqXUbElyt89d0obocL7C/ge2T6hKh?=
 =?us-ascii?Q?PB6gaSuATSuopq4kW9dID8RiRqPzh4cpm7DXC0Ovdv2ccrsDd7T0RgBvVFZm?=
 =?us-ascii?Q?LxQ6pedA6J/g7aUZ+st2/X+qgeCL4hQcUKg7/elhfrWzvrlAl4EgfjG+cWqA?=
 =?us-ascii?Q?1FNrP2MIWryNxrc2yGKb2+UzLYPtMaxJ5Z+zdc27vwi0lFBMD2TCxqq6jSU0?=
 =?us-ascii?Q?XAUZHhGRJj2qy862Eek+5V6GRmCitCFLiDMHxQ4ZmRtj0rO3pYhdvigujua+?=
 =?us-ascii?Q?06c1VxxAr5l7/+lsrJ6V61oAmdyfRqQQupes0WXoC/JZD+ZYU0EXyV39zZ3c?=
 =?us-ascii?Q?whdslOvWEfM1d2LpQxcOtJx+ByM++46jNIOAHlLPX9lWtCY1nrEWQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x+phXMlo/wtQanKJXDjllrFG2h2UFrjLaSgMrACpsfjh9CILRaKYOHrbvUGx?=
 =?us-ascii?Q?5rafzbQQ5ts84kRoGLQtQbi0qso+1uRn/OLl17o9UwSnURo4t26FzLr1LHfN?=
 =?us-ascii?Q?fcsBzBzbyarKyzDTOj6YtN5WSl8aRSX2tD6kpA9WIIn3uUDnGMzxPOK2SkLt?=
 =?us-ascii?Q?7KMb5L5x8z5ejN8yPWAZRZieN7/Xk3euPAr11iY24GGObEGNUSGVRt5HWf9L?=
 =?us-ascii?Q?ASBvEaWm4/15K5/36UiKjHTOZfSHO9866eRzdIECRrE98dYC7P+JENDsyYQR?=
 =?us-ascii?Q?BpFtM/kQ2GzEPWn5Vk8hMB0A8t5IP5RfMsl0v7md3ultS1wlrg/7EPAw+38v?=
 =?us-ascii?Q?nnUr5gpDChFFUv7JZenNcAPyb5QXoF7ChP2jaYX3Jgyd3igZGd9eyacBJBsl?=
 =?us-ascii?Q?UaeDoTu2wo7Nzx1+8+D36sxDJFoMVVOQsA1hhop7akTJZ+a/mAP+j1wbfRwH?=
 =?us-ascii?Q?hUIXAK3kRpvHAXCjkMlRuWRfcs13cDqmYgf17QHq7wpJSXR3v6x78UEyCxGr?=
 =?us-ascii?Q?1YF8WoL6Qfwy6Vf+vWM+f48ZxxgE2IDCdprS0Rv/NPENesRNiTjuZTqRgl8c?=
 =?us-ascii?Q?3e2CqDomMDS9G0rmTgF+rZjDnZpQbzvDk/vg6S8HnaCzN7zypXLmwEzwiuOT?=
 =?us-ascii?Q?+phzESBIN/dS962ctntT4J36gp/5GA3qAtJEGQUKEO2dVqa/6Mc1agde4uZU?=
 =?us-ascii?Q?mnFx6zeMujj/iHcU8MY14dcEw4PnKWwLB9PXHDx4y4mtF1K/7vGB3j43BA0a?=
 =?us-ascii?Q?GM6jhZaobiN+zVPdThuFEMY3CB9lFLQp6h3xqoanr6wun1SrgNqh453+gNfJ?=
 =?us-ascii?Q?3AfxjnG6k6Bvvg7AeF0rFzg0UY8XXavOaif+h3yi4FXBQavgHGu9o0a9Anco?=
 =?us-ascii?Q?t3hIjS3kV3EXGLj7jw8y9bAz9wEUFyQU2G11ZDFpbG9D0xvdA1F/+0aj/oKe?=
 =?us-ascii?Q?RwPKw48Ini9YZlMgVMe31bPrrCMxWZh5WMMboXiH8FrpUw9QM1xSsye1hjQk?=
 =?us-ascii?Q?Yb3RvHCklS6qOZfQBcBAkwOqn40mTF24XMsicL6lFjEtUitVlrRjUpc/wRJm?=
 =?us-ascii?Q?2cFJiU9RTeXb4x/f0VY+0teScEsH/HtSjpPYulah+ATBbA+2cXaj7NauKGXl?=
 =?us-ascii?Q?qar3crdOB/EX0I+ab0h2MiQ5fUNiHOUJ4+kVaXYy9r/KO2qVjm3vjz/ANcZd?=
 =?us-ascii?Q?aE2qqJsynYSkCGxKXIjQoWojXjL7RO6Qbnrpz5C+UOoYo7suh9L3cBBmT6iJ?=
 =?us-ascii?Q?mJQQerc7yLYcztfrZsqNOERGJW3DWCFPea0EP3rP0WrhubZ3rds5bdZATcBA?=
 =?us-ascii?Q?AAzWA8g5suLwR0DqyMon6NjtjH+pzchUtTtCAqhBpT9pBOym2Hqmqww6Kkrz?=
 =?us-ascii?Q?YbslAY1U9UIvZwo635IWYTxaVmQytrksBN8Oig7FUlnt5On/efI/sVQ24HKk?=
 =?us-ascii?Q?sh4nYurwdP01gIBBG2geYdcABIj5Ffh4XCrN7R269y4B71dRGhX8VZqGvqda?=
 =?us-ascii?Q?pbpFvQqfENrsJFyL1eNeORcIKNKEl+nSmyc3jHWPNonmhSWy/yF0Sl+9scSA?=
 =?us-ascii?Q?vHbEuNnWSa7pGWPdl18YkZ0zEIovGQRRv/OLt4MA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77303b7d-3aa5-49a2-a5ee-08de13d9ea42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2025 15:19:39.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSkjwP495yvibpnW/kNtsAPeBWW54xfZ03Iai+k9sw2vdn8U+xMthQee1LKcVc6o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476

On 24 Oct 2025, at 23:16, jane.chu@oracle.com wrote:

> On 10/23/2025 4:12 PM, Andrew Morton wrote:
>>
>> The patch titled
>>       Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio i=
s split to >0 order
>> has been added to the -mm mm-hotfixes-unstable branch.  Its filename i=
s
>>       mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to=
-0-order.patch
>>
>> This patch will shortly appear at
>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/t=
ree/patches/mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split=
-to-0-order.patch
>>
>> This patch will later appear in the mm-hotfixes-unstable branch at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when te=
sting your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Zi Yan <ziy@nvidia.com>
>> Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio is spli=
t to >0 order
>> Date: Wed, 22 Oct 2025 23:05:21 -0400
>>
>> folio split clears PG_has_hwpoisoned, but the flag should be preserved=
 in
>> after-split folios containing pages with PG_hwpoisoned flag if the fol=
io
>> is split to >0 order folios.  Scan all pages in a to-be-split folio to=

>> determine which after-split folios need the flag.
>>
>> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned =
to
>> avoid the scan and set it on all after-split folios, but resulting fal=
se
>> positive has undesirable negative impact.  To remove false positive,
>> caller of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_pag=
e()
>> needs to do the scan.  That might be causing a hassle for current and
>> future callers and more costly than doing the scan in the split code.
>> More details are discussed in [1].
>>
>> This issue can be exposed via:
>> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface=
;
>> 2. truncating part of a has_hwpoisoned folio in
>>     truncate_inode_partial_folio().
>>
>> And later accesses to a hwpoisoned page could be possible due to the
>> missing has_hwpoisoned folio flag.  This will lead to MCE errors.
>>
>> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=3DcpRXrSrJ=
9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
>> Link: https://lkml.kernel.org/r/20251023030521.473097-1-ziy@nvidia.com=

>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order page=
s")
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Cc: Pankaj Raghav <kernel@pankajraghav.com>
>> Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Jane Chu <jane.chu@oracle.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Liam Howlett <liam.howlett@oracle.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Luis Chamberalin <mcgrof@kernel.org>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Miaohe Lin <linmiaohe@huawei.com>
>> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Wei Yang <richard.weiyang@gmail.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>   mm/huge_memory.c |   23 ++++++++++++++++++++---
>>   1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> --- a/mm/huge_memory.c~mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-=
folio-is-split-to-0-order
>> +++ a/mm/huge_memory.c
>> @@ -3263,6 +3263,14 @@ bool can_split_folio(struct folio *folio
>>   					caller_pins;
>>   }
>>  +static bool page_range_has_hwpoisoned(struct page *page, long nr_pag=
es)
>> +{
>> +	for (; nr_pages; page++, nr_pages--)
>> +		if (PageHWPoison(page))
>> +			return true;
>> +	return false;
>> +}
>> +
>>   /*
>>    * It splits @folio into @new_order folios and copies the @folio met=
adata to
>>    * all the resulting folios.
>> @@ -3270,17 +3278,24 @@ bool can_split_folio(struct folio *folio
>>   static void __split_folio_to_order(struct folio *folio, int old_orde=
r,
>>   		int new_order)
>>   {
>> +	/* Scan poisoned pages when split a poisoned folio to large folios *=
/
>> +	const bool handle_hwpoison =3D folio_test_has_hwpoisoned(folio) && n=
ew_order;
>>   	long new_nr_pages =3D 1 << new_order;
>>   	long nr_pages =3D 1 << old_order;
>>   	long i;
>>  +	folio_clear_has_hwpoisoned(folio);
>> +
>> +	/* Check first new_nr_pages since the loop below skips them */
>> +	if (handle_hwpoison &&
>> +	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
>> +		folio_set_has_hwpoisoned(folio);
>
> Not sure what am I missing, why are we setting hs_hwpoison to the
> pre-split old folio here?  setting it in a new >0 order folio below
> make sense, setting it back to the big old folio in case of a failed sp=
lit make sense.

1) __split_folio_to_order() never fails; 2) this is for when any page in
[0, new_nr_pages) has HWPoison set. Like the comment above
this statement said, the split in the loop only check [new_nr_pages, nr_p=
ages)
pages. The statement above checks [0, new_nr_pages) and change the origin=
al
folio flag.

>
>>   	/*
>>   	 * Skip the first new_nr_pages, since the new folio from them have =
all
>>   	 * the flags from the original folio.
>>   	 */
>>   	for (i =3D new_nr_pages; i < nr_pages; i +=3D new_nr_pages) {
>>   		struct page *new_head =3D &folio->page + i;
>> -
>>   		/*
>>   		 * Careful: new_folio is not a "real" folio before we cleared Page=
Tail.
>>   		 * Don't pass it around before clear_compound_head().
>> @@ -3322,6 +3337,10 @@ static void __split_folio_to_order(struc
>>   				 (1L << PG_dirty) |
>>   				 LRU_GEN_MASK | LRU_REFS_MASK));
>>  +		if (handle_hwpoison &&
>> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
>> +			folio_set_has_hwpoisoned(new_folio);
>> +
> Looks good.
>
>>   		new_folio->mapping =3D folio->mapping;
>>   		new_folio->index =3D folio->index + i;
>>  @@ -3422,8 +3441,6 @@ static int __split_unmapped_folio(struct
>>   	if (folio_test_anon(folio))
>>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>  -	folio_clear_has_hwpoisoned(folio);
>> -
>>   	/*
>>   	 * split to new_order one order at a time. For uniform split,
>>   	 * folio is split to new_order directly.
>> _
>>
>> Patches currently in -mm which might be from ziy@nvidia.com are
>>
>> mm-huge_memory-do-not-change-split_huge_page-target-order-silently.pat=
ch
>> mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-ord=
er.patch
>>
> thanks,-jane


--
Best Regards,
Yan, Zi
