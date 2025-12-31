Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021129.outbound.protection.outlook.com [52.101.95.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0646199FBA
	for <mm-commits@vger.kernel.org>; Wed, 31 Dec 2025 23:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767222911; cv=fail; b=L5kndfc7IowRGgj5lnVMIzB+LYSKLya/BwC5rlK8DGFMBStbMokYT0hZbyPWGMUq+LXkhn0n3CWF9BX6DgDpKECdXWNk6Uq9KC5CmOxHc/mBfWl4fzVHvXdyyuQVtkckKaMvTtFnFWcctUma0gjpb2asUe+3V/U57Z+f9mvP0eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767222911; c=relaxed/simple;
	bh=CndblYtKrWBxagnWGTlH8rRceBe7tj7EfMZnO0DC16U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E3PU8y1SJ/764OIKyX18X0B6XRfHIsTm2w+aszXwlTxC+aN9DASjNDkPPjxkyoCd8PasmAQeCc/rKWwDphg2KcpDU2bvZr+tGe4MHgMoGvI7p5vO7K8MlSki8Hp7/O3NmPJwP8mnQSZLqsR7WRo+z4I/DJ3tfIJnskaY8EobfLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGVRjA10LSTx2+WHVEO6NkY8SSqiEORQunT9AV7EvwJ+1m2f9WsW9fvYleAouga4SWHQDtvlF1kxSAVieG8EOoA6TZxWaF76uhnQJUGVCznXWO8gys6JCh4x4PC8NAqqt5M3S9kXMGR5J5NnVDiRB05+Gx2/mZKmW4buAd6vizk3XW1FArS5NAPahYTzPitzrAOL6714MR6Gy1UPdcBmsZp8rZPBJV295eZBaTQC7Vn0xrQCWPPf+vs7RwFVIx2KFZSd7tlKuIIZiqfVo6Kn59FJsi2IqBeHSj5oArbJ6j504M13hrmdF7lcq7St8AlrjS4gvqz3lmNfcXVq2L2QJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plZ0QCBn/+KHXGaxVvoWZIvRVRD6XINOdIn03/7bjBA=;
 b=kEN3YLWZeE3azlzz8bgUxsgUfqLfo4IFZsEwPeVyDY7bmjbt7HUrkA/z6qGBZp0knQA1Yhbdvz2KTtqPeKDfkTuTs2vNLz2ktyduczYWgCTGSrGptUpQAmmR8r94csipFSY4bv5R9mIO/p2C/AEgaZPAweEmCOeIveROYjDObM/W5D3/DgHkTDTWEOMRAvOYA5tfWDLot33xRBHTTVprFn+sXFq7mFIe7kop2evmZJ6oP6sx0nJR/LSPbQ1EdY5H1QbR734nqlEGbPv/yerXpbtasxI8ARd/a3GAHq4yIzZJDbFZB3cTPQzgo4NNTLKlnslwXcpALoLK1LdWsm+/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2883.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:5b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 31 Dec
 2025 23:15:02 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 23:14:59 +0000
Date: Wed, 31 Dec 2025 18:14:55 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	oleg@redhat.com, mingo@kernel.org, gregkh@linuxfoundation.org, david@kernel.org, 
	brauner@kernel.org
Subject: Re: + fs-proc-expose-mm_cpumask-in-proc-status.patch added to mm-new
 branch
Message-ID: <froovn7y4nj2qartbgeypuxbg3exwh6cczrhkdsmsaoleaiiue@e5a56ebl6fvz>
References: <20251228192403.10773C4CEFB@smtp.kernel.org>
 <2a537a45-d75d-41e9-96a7-aefd14420ef2@p183>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a537a45-d75d-41e9-96a7-aefd14420ef2@p183>
X-ClientProxiedBy: BN0PR04CA0209.namprd04.prod.outlook.com
 (2603:10b6:408:e9::34) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2883:EE_
X-MS-Office365-Filtering-Correlation-Id: 045e9aea-85a2-48fe-5beb-08de48c26aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|41320700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3dRL2kyaXA5b3dOQzVZS0dPVUE0OTFZMnJXMTd5T3ZHekIxL2pldlBST2ty?=
 =?utf-8?B?ckNpQ0x6WTNleTZEaU5rVE03Kzh5R2FMM0tPMmdnUWZITkNuSUlRWlhZQWpP?=
 =?utf-8?B?MlQ0R3M2M2ZOR0NVeGZDRmxOOC8rMm1CQjRTUmFQdlllZkwyZ2JyMnVKYlhV?=
 =?utf-8?B?eWRLOVlDR2hMY2pIZ2ZYM3U5OUdHNURsSG1Vb3BxcUMxZGtaZUcrUTVFUEdv?=
 =?utf-8?B?VTRwUlB3NEdmdU5nTWNPR1V1d1VpaitjL0N0ZU9UVHVGR3dBZ2ZCbTI4SVp5?=
 =?utf-8?B?d0gwa0EwNS81cXc3YlJQOGh3SFFnYVZZQ1BFWGpRNFljTXY1dGhVWnpqOXNW?=
 =?utf-8?B?SDFPZE5JOThlL2ZlTk1taHNpeDg0cWp0Z2tZZDRtWlFWR3NGTXl0bk1IVmJw?=
 =?utf-8?B?aUl5c3BXdm40M1RoV2s3QVlHOTFFVGZta3RRcG1PQnYxTnlFOEdKQXY2S0hO?=
 =?utf-8?B?VzhqOHVBSnZvSU1nVDBlWU5aVUxQR20rZ2I1cFpRUUFaMFFMK0RuQWpOdHk1?=
 =?utf-8?B?NmZPcFFNaEdYMFRKTlltVi90d0w3VkVZbTllR1hxWEQ4NG4yUnJ6ZEt4bG5L?=
 =?utf-8?B?UmVtSG03dFdTbjZiQ1FCNUtES1ZPVVYwYXlCTDA4OFp3WlBYRXplNEVPaDFa?=
 =?utf-8?B?cFlqaGR6bGZuZTRNTWpqSkZsekxOUFB2aTNDL3QxdkhWSWJpdGEyRGNyTEtU?=
 =?utf-8?B?YUdoa0hValNLTDJMalRWTU84N2lwc20rT2Z3cElzNnpQUVRUd0lUWmttZnNH?=
 =?utf-8?B?b2p0cXBvYjVUT2VIekRJMm9zQmthRTAyYnp4RGtSd0taOVk3ZitDRHZtaDRK?=
 =?utf-8?B?S3U5VDFvK01ucExmalNuU3hXbDZWNFNmckVTVkR5aUpTbURJYnFHeEFBcEZP?=
 =?utf-8?B?VnpmbERBS09HT0ZCRUJlUHp3L1RyYmlaTWp2d1BvMHVxWFNnbWw1czdJcHVJ?=
 =?utf-8?B?MVYwdEdoWGh0N1ZKSGRjYlpuYkNTanZoellBRjRMRENXUXU4VHk2NmFTcEVU?=
 =?utf-8?B?ZGJseFpPem1xREIrVDE3TCtEcThxU2NyUExteXZwcXJBWXlWMFQvQ3A2cnJm?=
 =?utf-8?B?dS9BV2N3aUt3cjhSVU56endqL25aVnFSbmg0ZW5BM1dHZFowNnA1SFErdzZj?=
 =?utf-8?B?dDY4WjJHNDVjcTE4dHZ4VUphVjlDaDF0Z0JqUHJxZ3A0VEZUQ2dZTUp0MDRF?=
 =?utf-8?B?V0dvbkU2Q2VXdngvanVYcC9yaUtBM3hpNlM1cG05VVF0dmVRSTFUMXBnR2NV?=
 =?utf-8?B?azJ0WVNyNmVPM1M1NlZ5TFRFZkw2eDg1NnBVY2JIdVhXbUtURUNQdTN1dE55?=
 =?utf-8?B?RFNTbS9MdWI4VUk3QVV0bGN2NDVMU2FiTnR0aW9maXl3Z0M1ckdYL2pPMEh2?=
 =?utf-8?B?VjY2NGtXMFFQTldZVEtEL0dxckU2L1BhcUNnMk0ybVNaR1NqdXBvU2VsR3NY?=
 =?utf-8?B?S1NKeSs0QXdZS21RbGV6SytTSndzT2FLQUFXRE9rN1ZqWllOZ1pKdmh4UjZ6?=
 =?utf-8?B?dHZhUEY4eUZiU2RPTUZHVUhqdldxSHQrcWVlbXRQS1daeVZvY3Q3SlJPYlZD?=
 =?utf-8?B?MVdjcXNVNzdWZldUeDN1RVJNNVN3bVVCazcwZG9DVGdIMjZ1aHF1NEdaWFJp?=
 =?utf-8?B?ZERhWjFIS25CbDJPcGw1N2FsUExuK3ZKS0gycDdyQkFKb1ovb1JaZ0VkOGRT?=
 =?utf-8?B?c3RoZlNYekNrRjVKMGpJU1dvSDR0SmpGWlVoRGdmNnZpbXFCYmFuWjJESzZ6?=
 =?utf-8?B?Kyt6OFFMdVBuemVOT1pkUVBGSU9nMkhDVTJURzl6VExOZXpld2JGeGNjRnQ3?=
 =?utf-8?B?ZEpWQTVIUVZnSEJValJNYU8rNWluT2ZCOEhVR3FkNkRaZ25zbFBxajFQY3Nz?=
 =?utf-8?B?TUtNaVlTN3loTGZTTTdlcFRBVDlCVU5XcmFockFjTG91bSs2WXBtRzBCR2V4?=
 =?utf-8?Q?xtX2VwX/JtnBnoml+5g32JTTlr5nftqB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(41320700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1hYTlg5YmRNZHp2azUvdkhJMEhYcFdsSi9nbTJtQ3A3d1A2ZXdYTHlMeFNt?=
 =?utf-8?B?VGlWcjVjYWpxTTFDRlBMam5TLzBOYjRlWWNRbCsvODdCSkxnWm13ZGxxeTI3?=
 =?utf-8?B?b1VXeHZLV2ZRcTdhZ0MwOHJ0VEJLUUxiSmJnQlJydmhsak1WOFlMRkNXR1lu?=
 =?utf-8?B?RlhuWjY5V001bktiOWo5SDFmbWJXdGhUWVBIV0lZVzhxR3VLa1VSRXNPazMz?=
 =?utf-8?B?S2s2cy9lNGFyOFpXMTNCV3BacThKVmZZOHE5d1pEa2grNi80dmN0bDh5RjI4?=
 =?utf-8?B?bXR3bUZ5UklkNTh2bGZmY29qVlZNVTJHSVFDaS9zTmlVWDI1WXlYMjM2a295?=
 =?utf-8?B?YW9xMzE2eGoveDA3czZEOWFkSlQyK3c3U25yZmp3VzFsQUN0YzFDdjFJUHZ1?=
 =?utf-8?B?T1BUcVhRVEZ5bnNFb0EzUjhzQk80UXdGRXBjNlNMLzdJbTlCZUJDN1ozcXcv?=
 =?utf-8?B?OGVoZ3lzRWtmamQwVjE3T3N0YlZHcXJKYlNEVUIwRElvMkQwY3lMYklXWU8w?=
 =?utf-8?B?RnAxQXlKaUQ3aHdDeUFKRWF0K3E2WXJUVUdHa2daWUd5K1NIVDE5U2MvNkI3?=
 =?utf-8?B?OHZ3WHc5UUlSenFnd2laMlhqT3BGcllkalRpdklaNUpaYTN5T3FsaC94SytM?=
 =?utf-8?B?UTA0UFpySUZhMDE0bFNoa3EwYVNOZm9kZG11YnFMRzhzZVRCTW1uSEdlWGYz?=
 =?utf-8?B?N2tZSnRGVDlzam1UUytjK1Q3Q2V4YjEzNXhjeEE2M1JPa1RPdkgvOU9FU2N5?=
 =?utf-8?B?TlVrbG8yNVhZWUFjRmtxNUpBeTNHaFhwRGdCMEVDeDBwY2dHTTJqTW5Ya05j?=
 =?utf-8?B?VEV5OEJuYkliRng1K2RRakY3MUxRbER1YmlrM0dMYmRsNk1EdE5ReDVTQ0tV?=
 =?utf-8?B?eWp3MjJ5cHlTeEtCdUlQSjdzR0E2Y3hCMks5Y0JvdUUyZ1Q0WndmbVN4anhK?=
 =?utf-8?B?QStUT1FPL1J6Uk4zUU9WWmQxOVIvTUJxSHRCY2dsaHliWHR4MHRLcGRKUDJ5?=
 =?utf-8?B?VXhvNFVkNWZWUjVwcU5udFFtczVoL2hxemhaZWJnZm5WQ1JxTTZhT2JMTG5u?=
 =?utf-8?B?OENZTFRFejNnajQ1a1pSQjd2RVArZjZydW9NSFBGREZLS2ZJSkhMOHZnOXBk?=
 =?utf-8?B?TW1zKzlRcFdVUzJXN2dJVUl6dVBWUkFvSXEzeVVkbFBCTnJDY01CU2VzdGxa?=
 =?utf-8?B?N3lyeGRtWGIyaWJrVHNOUzNGY09idjhTdm9pMFVUZ0x5VGIwWTFKcjZEM1JI?=
 =?utf-8?B?d0NRVlNONnUyRmtTVzU1cVc1Q1dCTGJhVXhDKzI3NUJ4aTFSYmVXVXE5eDYv?=
 =?utf-8?B?OGZCNTJ2VnFQK2V3R3ZjN1B2NGpsK0tqYzBncGMvVUhkeGU1OWtpUmpwSU5O?=
 =?utf-8?B?L3BJNStuU01lT05aRUNzQmRVVDIrNzIrUDJFSTBBbEtZd25xNTJHVHpBb2Nk?=
 =?utf-8?B?Mjh6YWtRMnFSUzl2MnlrcEpHa1BZNFV2cDRiNEVVUEpTNTJiaW9mZkxKdXp1?=
 =?utf-8?B?OUpkMUdsWHZMV2dGeVgvdDV3ZjVsY3VPTVU4NkRpdUFaT2NLYVRCaWRnRUVu?=
 =?utf-8?B?bnNSSUJ6SS80Um13Tk5PazlFaTNzQ3FYRWlTSXBwR1M4YlJ0TGpRSUdZNnJ6?=
 =?utf-8?B?dytrM3cra0krWlpHQTZXTFA4MDU4YjJ0c0JZbFlRU3luZlE1dk13aFZZeWRK?=
 =?utf-8?B?ekdualdrMXR5WjcyT3FiMFROb1Y4bTdKMUNieDY3YmI3eHlMRFptUW1QRzNt?=
 =?utf-8?B?VVIwdVZDN3lQUTd1d2xaenhlZE1DcWJwemc5S2ZLT3FZUGppTU5INXl1QlhQ?=
 =?utf-8?B?WS9wdVU1VU1IbzkwYTNpL2g4YWpUT0NFYzVSak1wSWtuZW5BTUYzK0FTRk05?=
 =?utf-8?B?cFpza2RGbnZFeFlJclI1L29uWit1YnlRNG9FTjVNajgyblkrd3pDUkw5OFRY?=
 =?utf-8?B?bEtJcFhQZUc1MmNqcUhLZStEZldDMkR6UlJzVWVsOTcvdGMrd05WU0l1ZjVm?=
 =?utf-8?B?UGZORDB0bmRydE5JSndybFpjZkk3TE9UdXF0dS9FWUpacU5tYjZSeVN3cUo1?=
 =?utf-8?B?cGJRd2RnbzlvcmVHVEl1bG93OGlsVHdMNGxsVzMxVzdXaStEOFVmWTBOMTc5?=
 =?utf-8?B?NWhEL0l0QzQyZnQzM3RtWWI3ZGpSazlXeUttd1IyZVB1TTFZZk1hOVFFN3FZ?=
 =?utf-8?B?cEdUVk50Rit6cVhuVWVwbXZ0TlV6dERYbmpMMWlWT0ozQmZFbWUxbkxXSzc1?=
 =?utf-8?B?MDd3RG1FcUhvSlVXZllobURxVHJKcWVreHUwN2xnYjM1VVNMejNMSXo0TGtn?=
 =?utf-8?B?S2xTbWZyYTRPMHNrV2FqUGgvVUtJQkxyblFSMmxIY3djNEZlOVgxQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045e9aea-85a2-48fe-5beb-08de48c26aee
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 23:14:59.2228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h09w3/KJRV3Au6iLg7VYw5Ie+/yNd0D5as2XLhINEl0urLJE3Zxq+K9b7gY0V8rEXMsOBkcOVUGdFr5VgMoZQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2883

On Tue, Dec 30, 2025 at 07:23:50PM +0300, Alexey Dobriyan wrote:
> On Sun, Dec 28, 2025 at 11:24:02AM -0800, Andrew Morton wrote:
> > Subject: fs/proc: expose mm_cpumask in /proc/[pid]/status
> 
> > --- a/Documentation/filesystems/proc.rst~fs-proc-expose-mm_cpumask-in-proc-status
> > +++ a/Documentation/filesystems/proc.rst
> > @@ -291,6 +291,9 @@ It's slow but very precise.
> >   Cpus_allowed                mask of CPUs on which this process may run
> >   Cpus_allowed_list           Same as previous, but in "list format"
> > + Cpus_active_mm              mask of CPUs on which this process has an active
> > +                             memory context
> > + Cpus_active_mm_list         Same as previous, but in "list format"
> >   Mems_allowed                mask of memory nodes allowed to this process
> >   Mems_allowed_list           Same as previous, but in "list format"
> 
> > +static void task_cpus_active_mm(struct seq_file *m, struct mm_struct *mm)
> > +{
> > +	seq_printf(m, "Cpus_active_mm:\t%*pb\n",
> > +		   cpumask_pr_args(mm_cpumask(mm)));
> > +	seq_printf(m, "Cpus_active_mm_list:\t%*pbl\n",
> > +		   cpumask_pr_args(mm_cpumask(mm)));
> > +}
> 
> So this is 3rd pair of values which represent the same thing
> but can become desync during read().
> 
> I also wonder if anyone checked %pbl code to survive printing unstable masks.
> 
> 	/proc/alexey

Hi Alexey,

Thank you for the feedback. I see your point regarding the potential for
desynchronisation between the mask and the list formats, also appreciate
the concern regarding the stability of the %pbl iterator when traversing a
volatile bitmap during scheduler migrations.

However, I would like to propose that the patch remains suitable in its
original form for the following reasons:

    1. Consistency with Existing Patterns: The current implementation of
       task_cpus_allowed() in fs/proc/array.c uses this exact same approach
       for Cpus_allowed and Cpus_allowed_list. While mm_cpumask is indeed
       more volatile than cpus_mask, the kernel has historically accepted
       this minor "tearing" in /proc to avoid the overhead of snapshotting
       or locking in a diagnostic read path.

    2. Avoiding Allocation Overhead: Using alloc_cpumask_var() would
       introduce potential slab allocation overhead on kernels with
       CONFIG_CPUMASK_OFFSTACK=y. Given that /proc/[pid]/status can be
       sampled by monitoring agents, avoiding the heap and staying on the
       fast path is preferable for a non-critical diagnostic field.

    3. Minimal Impact of Desynchronisation: In the rare event of a
       migration occurring between the two seq_printf calls, the resulting
       inconsistency is transient and limited to a single read. For the
       intended use cases—debugging memory locality and TLB issues - this
       jitter is acceptable and consistent with the "sampling" nature of
       the /proc interface.

    4. %pbl Robustness: While the mask is volatile, the iterator in
       lib/bitmap.c is safe against concurrent modification in that it will
       not result in a kernel panic or out-of-bounds access, as nr_cpu_ids
       remains constant.

I believe maintaining the "low-overhead, no-allocation" pattern is the more
pragmatic choice here, but I am open to your thoughts if you feel the
volatility of mm_cpumask strictly mandates a snapshot.


Kind regards,
-- 
Aaron Tomlin
