Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D35EB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 15:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbjGGP0i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 11:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjGGP0h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 11:26:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CD02685
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 08:26:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367FO9pm003196;
        Fri, 7 Jul 2023 15:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=svhRjKg+samjlKxZaJ8NPiMpQ4zmawuzIIlVQPcya8I=;
 b=1f5lq7R2B7aV8GmYtVohpsWsy5eDSMYiXEfbskEw/5YE2mXwoMWpr56JmbFrkqFqo8CM
 ZWkCnDZZ7wgb4PEbzYY3aQ1UWGcqmMqiKduK0roR5huimDdtT57KYbMyqQi8V9qsjSRZ
 AOwRSVIBd7wMu8y5EmDzo8wu27javzl30BNUJHysGPgdYY1LYVuevANZgUW9l4tIRxeW
 YBPjetdclNOkIaZIGysONWUT0s/KssKXWgx/VK6K62IJ+ipuxDRA2vioTpokNtTJrdRc
 inEKEHlmdL0bgMy1Vg/Ivg/Bc30R+aHJq3Ef8j6Ar4twOs5katwWkVpP6IQddr0XBQq7 4A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpn1j81pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jul 2023 15:26:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 367FPJWg033298;
        Fri, 7 Jul 2023 15:26:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak8s0dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jul 2023 15:26:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbZnjugQyodcL+QQQAEl9vHE1KPEqSdt7QJz0Qt9hPml+P3IodrPu8UwZxIJ69qcfIr1NA+lxbhent+pL58RjMtzGQKo9fLZ4Ck6hawNKFKkcEfRCzhYbEdDxYc3fmSTbc1JbCnmiGOKXZ1n10HxWe/v0WbvCvNXt96DrXPDeXXJ2C3rjg77s8pSAr+WwEOwlIj1BqYu86uA3oYfxkce9P/ADt9KtR5AQ2Gbl+AeveITOWPS1oTuOezuI+PXgFa89fKXMMdhZ1mq9bQdW5IgjZjGuHj7ZVlZT0YxGXCPtWCQICk3UrCj/chtyqvV0iQBK+qW6TorhLOR79RX0oyzFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svhRjKg+samjlKxZaJ8NPiMpQ4zmawuzIIlVQPcya8I=;
 b=Frp8e903rI7PWjGv1DcruuhfnjKiuKfM0mLiXZkEivu01VR4C1Ks0ti/iRHVQMk7FKoL17m6GF9u2/A4WaGJfs6b4wPvMpP1GfY4LVQNvwkznLabQKzxtbU5LK20TP3OxHh5J7v0t3P9quqJceWFudcA/HrypvO7BnN56dI7Vuqg/jiW+E8fDyntcDu3PJKbku+1l8qcNnQqLHZ+OwSznXeUXElpl/nqPKGOoCOz0p7pOH8MPXR7NEOLQBVPgJaSv46LLrfdSzbeNG66K2K+fXQBhkhq0sJX3JWtD0kK2vr6Dj1xQDqSc7ZmOor93puhvOMlxnNtj6b4KH1w+eCKJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svhRjKg+samjlKxZaJ8NPiMpQ4zmawuzIIlVQPcya8I=;
 b=QDHmDvgT5QL+I/dj1ZmdwCkmccHUSxV1r3LllU3xDv3QHwMS3Sl2EncRLJMwtgiaRB2y9ctga7HhsE5jmWB3G2SJQoypuB9AEeoEyYGixw2lKP1+NZkiqTs8vbQ46drvv9LtHMqRtmOjis4D/jkrKHD4PtNTl3Vd3ILuU0JkOII=
Received: from CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
 by SA1PR10MB5887.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Fri, 7 Jul
 2023 15:26:25 +0000
Received: from CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::8b8f:b4b1:bb78:b048]) by CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::8b8f:b4b1:bb78:b048%5]) with mapi id 15.20.6565.019; Fri, 7 Jul 2023
 15:26:25 +0000
Message-ID: <52cf1639-cef5-cbf7-72c6-5eb030a880b1@oracle.com>
Date:   Fri, 7 Jul 2023 10:26:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: +
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, arnd@arndb.de
References: <20230706164151.3598CC433C8@smtp.kernel.org>
From:   Eric DeVolder <eric.devolder@oracle.com>
In-Reply-To: <20230706164151.3598CC433C8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::20) To CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4531:EE_|SA1PR10MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: af5c69d7-493c-4bf3-952c-08db7efe86ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpWYbHqRftS+mlNY71y+RNp7f36c5Ob7VXPvsBlwYp6WXWzOgKIZauBc+POJcLOSW7IFcSI4OEce4HtacCdGBSRzeLC8rLxpOW1UwA+yqcIdMfwPBQXM1WYAOtQ+/26uM41PDeH8Dc8Ty9XMSTX/sJhmnrzmvHEbLYnbN2UGkKuvLCRAr5IfuL+fQUWaJu1+vb5V5/u3ctBLTkYJdOfS5PJPYnEgXRpMO5gyxyDQgEtW9qjnGINIyWcCCNWZaEpSgfgvQ26gcdBATYVxXanSj5qb1QH97BI46JcxVV7bZQOJqRnFMZtT4cNzm4UFD908DZqD1l9TANCV/ouo+JFKcALNZtruRiwomagl1lqFnfXTLrGXWEf9uKiM4E0qEb6qDLAgqlnfVbTrvcpbd7csFSJ2+AX8JbXa3ANKNcyu74zZSWyrVB6QxspnaZ+0Nz9XRtxLmFiK8Qpc418F+wt08pFnPZuuIji/2UkAq96cKTSyi2WLSgt15sscaqG5YAR+cF+1hO+9HlhMbVj5kPDWraJpwYDTpi648dN02spP8ajIolT3ahXRX1caZOCOXLQI8qpj4UYSn7/XumVkRmUl+5n7A0arfivQ4YnwyqmcrRJoHwVOAwgIhUBgnbQoSLiXTlnUrTRMo7XoIKQqldpyhxD6gOvRRqZGmTvgRVYu+VM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4531.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199021)(5660300002)(316002)(2906002)(66556008)(66946007)(41300700001)(31686004)(66476007)(186003)(6506007)(478600001)(6666004)(6486002)(26005)(8676002)(8936002)(53546011)(2616005)(83380400001)(66899021)(38100700002)(36756003)(966005)(6512007)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE9FNitmZ0k2ZHk5MVBiOFd4ODlFbFlnK0hJVVhMb3ZEUmV0WW9UcWlEMVJ2?=
 =?utf-8?B?RlNDV3cxNzUvclhWRkt5K3R3TW1HOG9rR3ZJSmpKeGxxbURaelpHQVo1bTk2?=
 =?utf-8?B?bFhTSkErWkhWNW9IeURFUU5PQ1ZmOFpObnVGUWVsN0RodU81VE9WbmhJNUZH?=
 =?utf-8?B?a1dVN3FnMm5Nc0F4NVVNcnlYNE1jYnpzcVprUkZXeGFBZ0paUzBKK0VkQ1pZ?=
 =?utf-8?B?bkVlajQyaHpFTWhTMlVVRnhSdUd3cHphSFpLczEvTXhZK1A3eGcwRmVySzNn?=
 =?utf-8?B?TytNRHQvcnQ0Y3htTGQ5TFR0NkZpUUtWT3pyaEVFVzdIekRQbnExRC83U1I2?=
 =?utf-8?B?OE1udHBIOFIyUzdHQUlWdjE3MjFlZTVXdFhsU0tOUEV5c0p0VHFTSmkvOE5G?=
 =?utf-8?B?VWcySXhXM05EZGMzTTFyT1AxamRwUU0xZGsyaVJreTcxbDBlS05rN0xIQm5X?=
 =?utf-8?B?SGRoaW9MNmpJMlJuUUFCdCtIM2xRazlQZk4vbjVmQVRGSUZQZktGL3pkYXkz?=
 =?utf-8?B?MnkvSTIwVm1qb2NNcTFHNmpVdDNYcGc0WjJVSjg1T0RsK3Bzek9BN09JTFpV?=
 =?utf-8?B?Uml4QWZoTWJFRG5yWnhpWkc5WVFOWkt2dW56b3ovbFVDSWl1QWVHNjBnTUs2?=
 =?utf-8?B?WXo0WXJ0V29STmNkREV3MXBpZUtTZ1hIaHBPK080ektJL0hCY1BYaGM0UVpm?=
 =?utf-8?B?c3dIK3B4NTZNZEJCSkJqcDVVY1d6SnVTbEpQRHVIbVg0bXRJTys3YkdlcGxw?=
 =?utf-8?B?QVdCN3hiVGV6dkdUM1owTmIrU2xVSHBWaHFpMlFzeGJJNFB6cGxKNnBKd25i?=
 =?utf-8?B?L3g5am80THZ4NktReG9DVUpUbVQwSnlwcFh6MW9KOW9ENlJLU2FnNDl2a0NZ?=
 =?utf-8?B?SHdjcjFaSmpJRFd3MGZXakpCaCs5dWZFR1lOL3ljQXA2OVlPaUFaeVBXRy90?=
 =?utf-8?B?OUNKWUJGTi9odkFuMVcxcUx4UWZxK05uVkl2dVk4SDUwTTNiZ1pNTGF0SUFZ?=
 =?utf-8?B?VFh6MDNSUUVNZXVqaHhsNWtPWW9Ca1AxamN6TFFVQ0YzbW1lVnRGdzFQMU9m?=
 =?utf-8?B?VFVydzNIWllBR3hacG9sS0VzMzN0cTVNRE5FcEEySVVJOElVcDM5SDJMZDNQ?=
 =?utf-8?B?TmFIN29qTTFvYzNuMjlSNHNoTjZvQnc3cTV0ZHZWZStBVHlTYnQrMEl1bU5K?=
 =?utf-8?B?cEJKSGllUHdnb1ArQjNCK2MyRVd6Sm9JdEYyay84MUtxK0Z3ZzdUNDFpSlVx?=
 =?utf-8?B?ZW1RQUpyNmI3cGszWWJPdkcweFBjSFZHRG1qNGN4SFhLcHkzMUd6aTdlMXhW?=
 =?utf-8?B?OHUrN0piV0NCbUIzREo2NzYxRlh4YlRvR3kzVDZENHJZZzVSc3JnaEJXSHhX?=
 =?utf-8?B?akM4RC9tV1pPdnplcm1ZQnBLUTkzN1lLM2F2cnBhUUtBMWQxYWVxT2dzbVhM?=
 =?utf-8?B?TkRLejY2VDlaOXNnNWt6SllIazFkdjE3WW1mUTd5Q3crK0JJYlFKRlN0cmRG?=
 =?utf-8?B?aVA2aWF4WmxxRm5HNkk4MW5TaVdxdUx6S0V0SEZ0cGE4Nk5sajlkTU9hZVdV?=
 =?utf-8?B?eHc4em13TEtKclk4TzlJYmJMZk5MYTQ3SG1BR2VWbTBWdVJ3Z0FEVUlWT094?=
 =?utf-8?B?MUliMWtGdjZ0Qjc2eDU2L3NWWVFtaFVWYVFXdUZRUUh0SExIUUtSSmF2YUQ5?=
 =?utf-8?B?cTBLNDZPc3gzUW1DWGlCSnhtU2JUcng3WEJKSFFlNGNvZHFIaWRKMkFJdVRY?=
 =?utf-8?B?a3B3VUFqT0VwTmhsMG13bzRCUGRUS1ZEdlpqUzBSdGoydE5TTTlVNFV0VHdW?=
 =?utf-8?B?YjM2bStwR1AxTHgvOHp6QWc2OWNiek1Da1JuWEt6MkI0MFVNUVBWSytDRmps?=
 =?utf-8?B?Rzd3Q3VxanVOUU5jUVlMcVpLNHlkYkN2THZLWTZvRXM5b29iTkY3Vi9mNE5U?=
 =?utf-8?B?TVdQYXhrV282UnM1cEk2WnRkSkZNZUwreS9DNnB5SEkwUFhLdjczVnJublU0?=
 =?utf-8?B?QXlXTUpvYyt1bm0zWnpHV1pOR052TEY5UVo4VzZSZUlaLzFKQ0JFdTk2ZFVG?=
 =?utf-8?B?RE52OUExTmNkSk9paTZpbkRuTEZJakRKQTQxMFhrZ1hHKytYYnlXdXB2L2J0?=
 =?utf-8?B?Y2FKck9lSE9tc1NBY2x2NnJtMzluVUhsRWJ0NnNnOGhkSDBVY015KzVNekJG?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RqOGzhz6fLgZ30XvXUPG5Ws3bziAGiRSnazEl+X9Ve99pUfXlQ5b4uErahP5znApSnqwEYEsgTogL/qTgqtM2QxyFI/HWwAu22pd4xB8C6SuBc8L+yeoR7LRRhMkYGKcWx8pC8IP0tcnvga77nsJbAiSxz0Gd2eJrYVGvwlVA6WOOLn6bj/Y3w16wSup6o2EebxuUKU/ZqPFgz9wi3QNN+ErKL4TQZvVAZv5qawGEV4oa0FruqdZHxoTw26U8Z9gwiKZUZfFuHgr5cPL8NUGUKrDumZV+f2cPFvmA6RUIBXR+7jBjyGNLG7wjEEWcH/7em4Mi3ldhlaV3wUseTbos2DUHAlU1v/4U7IPL/EmBS4ao8/si5eJujMJcJzW1ad5OWrlhDs2b5BSwPkMdb82NR1iPI1g0ejoBAijIJ5OYp4kLkanTTzH5jDRGNwep+KuFzwSzJJRcK/oxupOSNku4eDebUFmeQdaZTYg53iRs6JUu2LZtNHpvfUml4qbig6wwVNJwVDKSMgRmx4/uy+H998qhGHICVuAmvBKcQGiJQPj49L6kqKOL5bq+T1EnvdNkC6SfivSE29z1jh8if5dlTLC+NdaZ6xaqEu2tPnNJYWE/YHPk7Ird6fAjY6NndXPj+e6c2IA4NzSZ/0w7WD6qOJvON3TD+rNPLrqqpYrl6mi3k3HOp+exP0kRCnLq0XXWKnBLWAAijsVaJ3y8cPbi1GvPhiuleCn0NZB0CYrl9hBrYPKO1GKs6+SWJWMFpJjdUqrHQh/HKUcoi9QnyYpvc+5qYv6EYb0brzIpKyORv9Ld1sqdiM1P9WkXDnkO9atFBNZgda+WIEbadiA3MLMZg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af5c69d7-493c-4bf3-952c-08db7efe86ba
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4531.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 15:26:25.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwZR+aAY27ezQxV3srjYbP1oMz0v1rcooD69Pp+NBFfahXJML/IDgarcESLGjnNfFOC7g2MoMsUm8kdoCORHegYZzOMTfVLIbtM5kH2agvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307070143
X-Proofpoint-ORIG-GUID: Bc8fkfXdyXiW52bHfMEYK88GZa4a44aV
X-Proofpoint-GUID: Bc8fkfXdyXiW52bHfMEYK88GZa4a44aV
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

FYI I posted v5 last night. It includes the effect of this patch as well.
Eric


On 7/6/23 11:41, Andrew Morton wrote:
> 
> The patch titled
>       Subject: kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: "Arnd Bergmann" <arnd@arndb.de>
> Subject: kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
> Date: Thu, 06 Jul 2023 14:18:36 +0200
> 
> Today's linux-next now runs into a warning on arm64 and
> presumably others, with the same problem as on arm earlier:
> 
> WARNING: unmet direct dependencies detected for KEXEC
>    Depends on [n]: ARCH_SUPPORTS_KEXEC [=n]
>    Selected by [y]:
>    - CRASH_DUMP [=y] && ARCH_SUPPORTS_CRASH_DUMP [=y]
> 
> I think the easiest way to make this reliable would be
> this fixup.
> 
> Link: https://lkml.kernel.org/r/c057ba7a-3cc2-44ac-a961-fa062b909876@app.fastmail.com
> Signed-off-by: "Arnd Bergmann" <arnd@arndb.de>
> Cc: Eric DeVolder <eric.devolder@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   kernel/Kconfig.kexec |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/kernel/Kconfig.kexec~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
> +++ a/kernel/Kconfig.kexec
> @@ -91,6 +91,7 @@ config KEXEC_JUMP
>   config CRASH_DUMP
>   	bool "kernel crash dumps"
>   	depends on ARCH_SUPPORTS_CRASH_DUMP
> +	depends on ARCH_SUPPORTS_KEXEC
>   	select CRASH_CORE
>   	select KEXEC
>   	help
> _
> 
> Patches currently in -mm which might be from arnd@arndb.de are
> 
> kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch
> 
