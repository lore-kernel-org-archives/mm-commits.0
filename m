Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2100.outbound.protection.outlook.com [40.107.215.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5615720B01
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="YvcsM6yW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALhzbiXe3odLo0rdMlSocAOx3OUiitfaSSBn4K+IUmea/y0ms9GFZtUQ4+ejULQkqwgbhZWwbvBBHmFQgQEwbV4KgTVXotgalHO/SFxUF/rsSrgbXUoD+kPyTcSJPenY6GjE2S3C8dfxEVwuPCiukUOaxFyMqhsLQmcrHyvruAuywRn6UymZZJRAOaevkOG8D2g/Y9njX2NAwA9We7weOFpVvlGm9sAePWtRwLshOO5MK9cD5HuBPlj28Fqq9b4LmoZQo8fqKO4bbnKQl3kgdXXAwOqUfo6UZzmFltFfKRyFHWE/0oLLjG+rNMAM7u2RQ7mLdqc5Z6NA70fM7HTNLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UcyRuFU8Arpe2iKRlr2p3AwT6tbrj6MET0dm3JwXMc=;
 b=RdQx7Uj1IT97jjNUQAH8Q9LM2w/YYcd9pqUYZzvOyZ9uaRP3vqIlYwPR4G/Xz/rAd7IBZVThAHHYG9l3gb5LkfxQQrnmd6ZGv0qlb76LaiORBUhenh82bntyS/bmH6hyG1vgd6cHOMmUe1GqKOkqbdTixTLbPCPqauYSBk0RCrwRyGwHeZwpYmdDDJ8XasCoxGFLo05QBczboq7qvynHgKo3+ObDNCVKsLjBb09ra0BPuJQuSUTrlfktQAcDAcAyxO7K5QgIitqA5tvmyFHHBsqYNfv7rsmR9uxMCF2bvlcavyVf3WqmMPBYs7xEC/ooNbdN7QFUVCCDx8VZMRMfCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UcyRuFU8Arpe2iKRlr2p3AwT6tbrj6MET0dm3JwXMc=;
 b=YvcsM6yW6FAjjvCArdDk8jFHDmuuhgqdAhAFi8K34Y7RYG2CYDzUItWhFBKWIo2hMvzftRBiUvlPjPpsKYrheQyWCwuoqqinFWt+A4bPGWG25qSAYmwzHWNwOz68hgc608sKgYz6pyLSYkHP8ko5ba20Yv667R+E/z1vCoWpE48iQL4etPtlMCwD/oAYCZQSkBF5h40KCHc62bGVZ8Zy6z+n5Ra/lDFVcargJ1oFbValhD3dzzea8Tq2HTDOOXcvBQISZvxSOXe3BN5oHd/sx2qU5xhvZ+eCff1OZL7llwaef9UVnV2kk/my28faT71kvKYEtb8NIjmhL5uiO0Fehw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com (2603:1096:400:21::8)
 by SEZPR06MB5879.apcprd06.prod.outlook.com (2603:1096:101:e4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 10:06:53 +0000
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5]) by TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5%7]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 10:06:53 +0000
Message-ID: <a453f2a4-c3c5-49e6-b9c3-531f1fd16e60@vivo.com>
Date: Thu, 4 Jan 2024 18:06:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 0/2] Make memory reclamation measurable
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: opensource.kernel@vivo.com
References: <20240104100145.3855-1-cuibixuan@vivo.com>
From: Bixuan Cui <cuibixuan@vivo.com>
In-Reply-To: <20240104100145.3855-1-cuibixuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To TYZPR06MB4045.apcprd06.prod.outlook.com (2603:1096:400:21::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4045:EE_|SEZPR06MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a407672-f588-419d-6e5a-08dc0d0ce035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s5vCGNkeBEEXLdRaDXDgU88HE1GhCaBQtcj1qZjl5wH9AMG7HNt1OTd2N1QdMadUYRq3n/WSBeLNWwKQ+urknMAqytrAQxwnfiHZ9ONvNs4CnQtx9cmhkfDnviYVYe2r7izR61GeeBzNiKrJBXURXNshHbTnC3eTrbHq5i+n9x9DFYCeJXVH5WxgsLqvjYgpK8RyFrQa+CyaNpOKRzO6b6nFuvaoB1Xrg3fEBB6Gh06eTadKL9daJNbShMBzxOwpOfoRAWs6+jq2oV2qHxVG2mxxoWWOfoaQmXHmh4wp0193ZEPSqDGsjZ6neSF/4zRbXtxlalgv7z2+Xda6/TANCZOSYdQD3EIyVEbgDCNjjADa9MWQMdxNcqJav10/NNk6rjzaqyMkUcmb9W0DhIVuFBE7uU2aP68M08jeyCD1dLRK1Ph9UGnMmxx2ghHW6Wi2a7e48M2G+X0kYKw2avLfnrw3qQ51r5V0rBHLnCm0CrTfOGXTYw/K87CdjoUKrmPoIcGq6c28U0AG3TVu8YGTMMBN1Hm5A12SuORkw7paAmJHgE6JUjSED7MU6a6EgZX6I2/+mt/vFpTDbCiWJhkpfGs3TMH1vcS+If+NzlMAPYwwgb6cIaifrAi9DcwGuJmkv7u2qMXpMW7Tls/04zMvl+UQ7kvK4QE01nI/CjONhRxt4kSWA0JxS/+VDSTXs5+e
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4045.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(26005)(5660300002)(107886003)(2616005)(2906002)(8676002)(8936002)(41300700001)(316002)(38100700002)(4326008)(6666004)(478600001)(52116002)(6486002)(6512007)(6506007)(66556008)(66946007)(86362001)(66476007)(4744005)(31696002)(38350700005)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXR6MkFiOHFaMUowd0RJR3JEWG9JNm5YSDFNR1dYTzRsVWpMZHBnSVNVcUZP?=
 =?utf-8?B?Z3p2SHZ0Um11T2syS2pLazFmWVRLTHdzMDNmTCtQWGlIUkprc2VUaVRGaHEr?=
 =?utf-8?B?Q2dKTTZPQmEyWVFTNFgwbG16M3hibUdmRC9iSUJCVERYUkdQdVhZUFBaNUIw?=
 =?utf-8?B?dUVQRjFBOE1idHd3emR1cXNNbXlSbDJyN0RZTFpKeDlVOGhzNzdVNnhjZ3ZZ?=
 =?utf-8?B?TFUyRDRzZ3pWQUUweTRlYlYzcE1FQzhzOG01VVJLd1RMclZTUXVkV0toYlU0?=
 =?utf-8?B?aWtDWWw4UjlvQUdIcDRRKzMrdmVOcjR5ay9GSDBFYjRwTm5wRzFVN2JmcTds?=
 =?utf-8?B?VTRoUm54MlVVdklReWp0Z04yS2pCWWlncFo3VmV0ODczVEVkT2RabXJFQTB5?=
 =?utf-8?B?SXBWMUgwNVU1V1c1TWVzdzM1SFFmWmI4RHd4cjYxSFI2VG5QZ0lyVUJQNE5U?=
 =?utf-8?B?anhNYTlxYlRyTmpxdDk0ZnZvdEV5TjZCNkwzT2JOVytzLzRqRTYrUitDL1Nj?=
 =?utf-8?B?a29ESVlxZmJvVm5lNFp5UDNqSXZUVUVPUmFFbm4ySFVtUW0wR3NCUW9rdDJX?=
 =?utf-8?B?RXc0NzlORUNzZFQ3QnlFcnd1cytMNUJidkR5YTUwWjB2eEw4bDRPY3UwNyta?=
 =?utf-8?B?OWljYTlVYkZBaVZtVU92djVpdDdNYU1ENENMaDdob014RmN3a3d1Vk1HWnhC?=
 =?utf-8?B?VW10OGVGV1daSTVnaG94dkg2M2NFcWEvaDgwb2hGd3FOMkZ2TG4rKzYxcmFR?=
 =?utf-8?B?a0F1SEhtRCtnZXFlOUt4OE1IWENXWVpVYU80TzdEUnpnSlBYMHUycmhjUjZN?=
 =?utf-8?B?dGNkbXFiVnhWaS91Z3JoYWN4SkJwclcrOVMzK2xOUHJ1azBDZUFISFZSNDJa?=
 =?utf-8?B?cHNxbm4xQzNsYnpJWVR4aGxnK2s0WjRIeXAyVGovTVJ2MWtKTkN2MHR2UlMr?=
 =?utf-8?B?RitEemU1V3U1b0pYVzRxRzRLZUgvaWt0dit6OVFLWjc2VkhENWhGYk82Tk81?=
 =?utf-8?B?aG8zQWU5T3JycTd2VzhGazJyVnRGcG1pd09pSDNyUFBKdjlsUzZVSks3VDFo?=
 =?utf-8?B?d1ViSSt4NEk4RUhpZkNyeHZCcjM0SGlORmhCV3Z5TzYwTy9DYUo2eUpqbW1U?=
 =?utf-8?B?Y3VWbXRyTjlTTHlVTWR1cS9jRno2cXg1TklsaWZEOUJNZHlwNXJPbmhNUjA0?=
 =?utf-8?B?VDB0Z2IrNUk1SkRpUWFEZFR1Ry9pMzU4Y3pHNW9FSnYvMm5nUXRYQVgzUHFr?=
 =?utf-8?B?cXpiYWk1bFpVRDBYekw1eWZVby9VQk83ZFVvUnNwZjMwNlFsYm5TL29aYWZV?=
 =?utf-8?B?MVJTdHFNNUpaaENkQ3ZXZjBEMXltcFBpbUh6Q3JJTnVkbTd4VUFxS3Z6NmN1?=
 =?utf-8?B?QkpyNGxvQitEbTFZQ0tLR3hqeTdVeVN0bHhLc2tQYVRaa2FrVmdpWXhxa1Nx?=
 =?utf-8?B?OHZvUUtoSGN4UnBlMXU0dnFOa1pUQjRQTnFGSmlwTjJ6MHhaTmZBQXNHVmEx?=
 =?utf-8?B?cUdQWCtwZTFmakxRR3o4YlhpOVFTZjZoOUsvWTZWUzBXMnVKaW1FdGd1S0Vj?=
 =?utf-8?B?OFNnSy91TVZnRlpiWllpakZ0amJMM3hhUmkwTEZEMTRMOGRDaFkrV1NhOEhO?=
 =?utf-8?B?dnhCVnYzLzcxdkRBSlVOaTN2VDN6NUtrUjA3VDdPWnZnTEZjWG1paWxLNWtJ?=
 =?utf-8?B?Yzc0eXpIUzNXMUlQTkpVekR6UnVmS0lBYnR2dGlneTFhUkVTMXE3SG51aWRR?=
 =?utf-8?B?WmlUU2YzZ040ZERuYmRPTEtQTDRNY0ZNNEE3SDhyeWtLQ3hYT1JJbzh5ZU5H?=
 =?utf-8?B?d2xNakJOOTVNZm93OWIxMXhDS1hIcTAveFM3bE9FRVByVjJSQXg5dDhsbnlP?=
 =?utf-8?B?YTQyUU84THZZMTdCYURzTFU2OVhNZzFRRXpzQnVBU2kwNFpBc3Nsb0JzOXdB?=
 =?utf-8?B?QXluYmFoZU9FZWtTYUV4ajk5T3hSTGlkb0REUFhPT050WCtLdU45eHJhMXQx?=
 =?utf-8?B?bzF3d3BtcEZCZHhFd3hDNXVSOTJMeXdhQ3pvREVxa200N0p0VGJIZk9PZVkx?=
 =?utf-8?B?d1J0dmloWjlubzhOYjE5TzhDaXIxQnp4VkJRdmxMUEFOdTdZTUtTNE9oRVU2?=
 =?utf-8?Q?pf9eBxJEWELx3WzmG5sdTzGgF?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a407672-f588-419d-6e5a-08dc0d0ce035
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4045.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 10:06:53.4106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1fqw/W6ksAY6Od2t89iitoEjMQcPlrDRy1mN+hkAiKTR7aoQ+0ytQt6iXjxXl+R+Trf4cdWhPW8p/QSwIWVcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5879

Sorry, ignore this email, I re-sent the v5 patches to the kernel patch list.


在 2024/1/4 18:01, Bixuan Cui 写道:
> When the system memory is low, kswapd reclaims the memory. The key steps 
> of memory reclamation include 1.shrink_lruvec * shrink_active_list, 
> moves folios from the active LRU to the inactive LRU * 
> shrink_inactive_list, shrink lru from inactive LRU list 2.shrink_slab * 
> shrinker->count_objects(), calculates the freeable memory * 
> shrinker->scan_objects(), reclaims the slab memory
